package com.nlb.controller;

import com.nlb.dto.request.ExamResultReqDTO;
import com.nlb.mapper.ExamMapper;
import com.nlb.service.ExamService;
import com.nlb.service.WebSocketExamService;
import com.nlb.vo.ExamResultMongoVO;
import java.time.LocalDateTime;
import java.util.List;
import java.util.concurrent.TimeUnit;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Controller;
import org.springframework.messaging.simp.SimpMessageSendingOperations;

@Controller
@Slf4j
public class ExamWebSocketController {

  @Autowired
  private SimpMessageSendingOperations messagingTemplate;
  @Autowired
  private ExamMapper examMapper;
  @Autowired
  private ExamService examService;
  @Autowired
  private WebSocketExamService webSocketExamService;
  @Autowired
  private RedisTemplate<String ,Object> redisTemplate;

  // 1) 클라이언트 -> 서버: "/app/submitExam" 로 메시지 보낼 때 처리
  @MessageMapping("/submitExam")
  @SendTo("/topic/examProgress")
  public String submitExam(String message) {
    // 여기서 받은 메시지를 처리한 뒤,
    // 전체에 브로드캐스팅할 내용이 있으면 return
    return "응시자 제출 완료: " + message;
  }

  // 2) 서버 -> 클라이언트: 강제 시험 종료 등
  //   보낼 때는 메서드 내에서 messagingTemplate.convertAndSend() 사용
  public void forceCloseExam(int examId) {
    // examId 기준으로 아직 미제출 수험자 처리 로직 (submitExam() 로직 재사용해도 됨)
    // 처리 후, 소켓으로 안내 메시지
    log.info("🚨 [시험 강제 종료] examId={}", examId);

    List<Integer> examineeIds = examMapper.getExamineesByExamId(examId);

    for (Integer examineeId : examineeIds) {
      String key = "EXAM:" + examId + ":USER:" + examineeId;
      ExamResultMongoVO mongoData = (ExamResultMongoVO) redisTemplate.opsForValue().get(key);

      if (mongoData != null) {
        log.info("[시험 종료 처리] examId={}, examineeId={}, Redis에서 데이터 가져옴", examId, examineeId);

        // 시험 데이터를 MongoDB와 RDB에 최종 저장
        examService.finalizeExamSubmission(examId, examineeId, mongoData);

        // Redis에서 삭제
        redisTemplate.delete(key);
      }
    }

    // 모든 응시자에게 시험 종료 메시지 전송
    messagingTemplate.convertAndSend("/topic/exam/" + examId + "/notifications",
        "시험이 종료되었습니다. 자동 제출이 완료되었습니다.");

    log.info("✅ [시험 종료 처리 완료] examId={}", examId);
  }



  // 1) 클라이언트 -> 서버: "/app/exam/answers/saveRedis" 로 메시지 전송
  //    examResultReqDTO에는 (examId, examineeId, ... answers ...)가 들어있다고 가정
  @MessageMapping("/exam/answers/saveRedis")
  @SendTo("/topic/exam/autoSaveAck")
  public String handleAutoSave(ExamResultReqDTO dto) {
    // 1) examId, examineeId 추출
    int examId = dto.getExamResultVO().getExamId();
    int examineeId = dto.getExamResultVO().getExamineeId();
    // 2) Redis에 Key 구성: "EXAM:{examId}:USER:{examineeId}"
    String key = "EXAM:" + examId + ":USER:" + examineeId;

    // 3) 실제로 저장할 내용 (MongoDB 구조와 동일하다고 가정)
    ExamResultMongoVO mongoData = dto.getExamResultMongoVO();

    // 4) Redis에 저장, TTL은 시험 종료 시간 기준으로 설정
    LocalDateTime examFinishTime = examMapper.getFinishTime(examId);
    long ttlMinutes = examService.getRemainingTimeInMinutes(examFinishTime);

    redisTemplate.opsForValue().set(key, mongoData, ttlMinutes, TimeUnit.MINUTES);

    log.info(" [RedisAutoSave] key={}, savedExamResult={}", key, mongoData);

    // 5) @SendTo: 모든 구독자에게 “자동 저장 완료” 알림 (or 원하는 채널로)
    return String.format("AutoSave OK => examId=%d, userId=%d", examId, examineeId);
  }

  @Scheduled(fixedRate = 60000) // 1분마다 실행
  public void checkExamStatus() {
    List<Integer> ongoingExams = examMapper.getOngoingExams(); // 진행 중 시험 조회
    for (Integer examId : ongoingExams) {
      LocalDateTime finishTime = examMapper.getFinishTime(examId);
      if (examService.isTimeOver(examId, finishTime)) { // 시험 시간이 초과되었으면 종료
        webSocketExamService.closeExam(examId);
      }
    }
  }

  // 서버와 프론트 시간 동기화 방안 @Scheduled 활용
  @Scheduled(fixedRate = 1000) // 1초마다 실행
  public void sendServerTime() {
    long serverTime = System.currentTimeMillis(); // 서버 현재 시간
    messagingTemplate.convertAndSend("/topic/serverTime", serverTime);
  }

  @MessageMapping("/flushCompleted")
  public void logFlushCompletion(String message) {
    System.out.println("📡 [SOCKET] 클라이언트에서 flush 완료 메시지 수신: {"+ message+ "}");
  }

}