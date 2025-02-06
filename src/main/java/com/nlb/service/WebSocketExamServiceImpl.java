package com.nlb.service;

import com.nlb.dto.request.ExamResultReqDTO;
import com.nlb.mapper.ExamResultMapper;
import com.nlb.vo.ExamResultMongoVO;
import com.nlb.vo.ExamResultVO;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.data.mongodb.core.query.Criteria;
import org.springframework.data.mongodb.core.query.Query;
import org.springframework.messaging.simp.SimpMessageSendingOperations;
import org.springframework.stereotype.Service;

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

    //각 resultId마다 강제 제출 처리
    for (Integer resultId : notSubmittedResultIds) {
      try {
        // RDB에서 examResultVO 로딩
        ExamResultVO examResultVO = examResultMapper.selectExamResultById(resultId);
        if (examResultVO == null) {continue;}
        int examineeId = examResultVO.getExamineeId();

        // MongoDB에서 examResultMongoVO 로딩
        Query query = Query.query(Criteria.where("resultId").is(resultId).and("examineeId").is(examineeId));
        ExamResultMongoVO examResultMongoVO = mongoTemplate.findOne(query, ExamResultMongoVO.class, "examResults");

        ExamResultReqDTO dto = new ExamResultReqDTO();
        dto.setExamResultVO(examResultVO);
        dto.setExamResultMongoVO(examResultMongoVO);

        // 기존 submitExam 로직 재활용 → 채점까지 진행
        examResultService.submitExam(examineeId, dto);

      } catch (Exception e) {
        // 이미 제출된 경우나 예외 발생 시 로깅 후 스킵 or 처리
        System.out.println("강제 제출 중 오류: " + e.getMessage());
      }
    }

    // 시험 상태를 closed 로 변경
    examService.setExamStatus(examId, "closed");

    // WebSocket 브로드캐스팅 - 시험 종료 알림
    messagingTemplate.convertAndSend("/topic/examProgress",
        "시험이 강제로 종료되었습니다. 미제출자들은 자동으로 제출 처리되었습니다.");
  }
}