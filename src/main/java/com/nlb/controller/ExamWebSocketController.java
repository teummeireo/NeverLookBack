package com.nlb.controller;

import com.nlb.mapper.ExamMapper;
import com.nlb.service.ExamService;
import com.nlb.service.WebSocketExamService;
import java.time.LocalDateTime;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Controller;
import org.springframework.messaging.simp.SimpMessageSendingOperations;

@Controller
public class ExamWebSocketController {

  @Autowired
  private SimpMessageSendingOperations messagingTemplate;
  @Autowired
  private ExamMapper examMapper;
  @Autowired
  private ExamService examService;
  @Autowired
  private WebSocketExamService webSocketExamService;

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
    messagingTemplate.convertAndSend("/topic/examProgress",
        "시험이 강제로 종료되었습니다. 남은 인원 강제 제출 처리됨.");
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