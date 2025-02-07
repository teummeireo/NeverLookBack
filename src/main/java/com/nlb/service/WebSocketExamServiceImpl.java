package com.nlb.service;

import com.nlb.dto.request.ExamResultReqDTO;
import com.nlb.mapper.ExamMapper;
import com.nlb.mapper.ExamResultMapper;
import com.nlb.vo.ExamMongoVO;
import com.nlb.vo.ExamResultMongoVO;
import com.nlb.vo.ExamResultVO;
import com.nlb.vo.ExamVO;
import java.time.Duration;
import java.time.LocalDateTime;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.data.mongodb.core.query.Criteria;
import org.springframework.data.mongodb.core.query.Query;
import org.springframework.messaging.simp.SimpMessageSendingOperations;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;

@Slf4j
@Service
public class WebSocketExamServiceImpl implements WebSocketExamService{

  @Autowired
  private ExamService examService;
  @Autowired
  private ExamResultService examResultService;
  @Autowired
  private ExamResultMapper examResultMapper;
  @Autowired
  private MongoTemplate mongoTemplate;
  @Autowired
  private SimpMessageSendingOperations messagingTemplate;
  @Autowired
  private ExamMapper examMapper;

  /**
   * 시험을 강제 종료하고,
   * 아직 제출하지 않은 응시자의 답안을 강제로 제출 처리한 뒤
   * WebSocket을 통해 공지 메시지를 전송.
   */
  public void closeExam(int examId) {

    // 2) 아직 제출하지 않은 resultId 목록 조회
    //    (예: submittedAt이 1900-01-01인 경우 등)
    List<Integer> notSubmittedResultIds = examResultMapper.findNotSubmittedResultIds(examId);
    // → findNotSubmittedResultIds()는 직접 작성해야 함 (Mapper / XML)
    log.info("[closeExam] 미제출 resultIds={}", notSubmittedResultIds);


    //각 resultId마다 강제 제출 처리
    for (Integer resultId : notSubmittedResultIds) {
      try {
        // RDB에서 examResultVO 로딩
        ExamResultVO examResultVO = examResultMapper.selectExamResultById(resultId);
        log.info("[closeExam] examResultVO={}", examResultVO);
        if (examResultVO == null) {continue;}
        int examineeId = examResultVO.getExamineeId();

        // MongoDB에서 examResultMongoVO 로딩
        Query query = Query.query(Criteria.where("resultId").is(resultId).and("examineeId").is(examineeId));
        ExamResultMongoVO examResultMongoVO = mongoTemplate.findOne(query, ExamResultMongoVO.class, "examResults");
        log.info("[closeExam] examResultMongoVO={}", examResultMongoVO);


        ExamResultReqDTO dto = new ExamResultReqDTO();
        dto.setExamResultVO(examResultVO);
        dto.setExamResultMongoVO(examResultMongoVO);
        log.info("[closeExam] submitExam 호출");


        // 기존 submitExam 로직 재활용 → 채점까지 진행
        examResultService.submitExam(examineeId, dto);
        log.info("[closeExam] submitExam 완료. resultId={}", resultId);
        System.out.println("resultID = "+ resultId + "examineeId = " + examineeId +"의 시험 종료");
        System.out.println("closeExam For문 안에서 DTO" + dto);

      } catch (Exception e) {
        // 이미 제출된 경우나 예외 발생 시 로깅 후 스킵 or 처리
        System.out.println("강제 제출 중 오류: " + e.getMessage());
      }
    }

    // 시험 상태를 closed 로 변경
    log.info("[closeExam] examService.setExamStatus({}) 호출", examId);
    examService.setExamStatus(examId, "closed");

    // 모든 응시자에게 시험 종료 알림 전송
    messagingTemplate.convertAndSend("/topic/exam/" + examId + "/notifications",
        "시험이 종료되었습니다. 자동 제출됩니다.");
    log.info("[closeExam] 완료. examId={}", examId);

  }


  //이미 알림 보낸 기록을 저장
  private Map<Integer, Set<Integer>> examAlertHistory = new ConcurrentHashMap<>();

  // 5초마다 현재 서버시간을 모든 클라이언트에게 broadcast
  @Scheduled(fixedRate = 5000)
  public void broadcastServerTime() {
    long now = System.currentTimeMillis();
    // 현재 on_going 시험 목록
    List<ExamVO> ongoingExams = examMapper.selectAllOnGoingExams();
    for (ExamVO exam : ongoingExams) {
      int examId = exam.getExamId();
      // examId마다 다른 채널
      messagingTemplate.convertAndSend(
          "/topic/exam/" + examId + "/serverTime",
          String.valueOf(now)
      );
    }
  }


  //    1분(혹은 10초) 간격으로 on_going 시험들 체크
  //  - 20분 전, 10분 전, 5분 전이면 알림 전송 (중복 전송 방지)
  private Map<Integer, Set<Integer>> alreadySentAlert = new ConcurrentHashMap<>();

  @Scheduled(fixedRate = 60000) // 1분마다
  public void checkExamsRemainingTime() {
    List<ExamVO> ongoingExams = examMapper.selectAllOnGoingExams();
    LocalDateTime now = LocalDateTime.now();

    for (ExamVO exam : ongoingExams) {
      int examId = exam.getExamId();
      LocalDateTime finishedAt = exam.getFinishedAt();
      if (finishedAt == null) continue;

      long minutesLeft = Duration.between(now, finishedAt).toMinutes();
      if (minutesLeft <= 0) continue; // 이미 종료시간 지남

      alreadySentAlert.putIfAbsent(examId, new HashSet<>());

      // 20분 전 알림
      if (minutesLeft <= 20 && !alreadySentAlert.get(examId).contains(20)) {
        sendAlert(examId, 20);
      }
      if (minutesLeft <= 10 && !alreadySentAlert.get(examId).contains(10)) {
        sendAlert(examId, 10);
      }
      if (minutesLeft <= 5 && !alreadySentAlert.get(examId).contains(5)) {
        sendAlert(examId, 5);
      }
    }
  }

  private void sendAlert(int examId, int minuteMark) {
    String message = "[시험 " + examId + "] 종료 " + minuteMark + "분 전입니다!";
    // examId별 채널
    messagingTemplate.convertAndSend("/topic/exam/" + examId + "/notifications", message);

    alreadySentAlert.get(examId).add(minuteMark);
  }

}