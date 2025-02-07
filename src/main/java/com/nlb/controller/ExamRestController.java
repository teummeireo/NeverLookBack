package com.nlb.controller;


import com.nlb.dto.request.ExamReqDTO;
import com.nlb.dto.response.CMResDTO;
import com.nlb.exception.ErrorCode;
import com.nlb.service.ExamResultService;
import com.nlb.service.ExamService;
import com.nlb.service.WebSocketExamService;
import com.nlb.vo.ExamVO;
import com.nlb.vo.ExamWithCreatorVO;
import com.nlb.vo.QuestionVO;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.messaging.simp.SimpMessageSendingOperations;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.util.List;
import java.util.Map;

@Slf4j
@RestController
@RequestMapping(value = "/api/exams")
public class ExamRestController {

  @Autowired
  private ExamService examService;
  @Autowired
  private ExamMapper examMapper;
  @Autowired
  private WebSocketExamService webSocketExamService;
  @Autowired
  private SimpMessageSendingOperations messageSendingOperations;

  // 정렬기능(제목, 생성일, 응시자수, 카테고리) & 필터기능(카테고리)
  @RequestMapping(value = "/{userId}", method = RequestMethod.GET)
  public ResponseEntity<CMResDTO<List<ExamVO>>> examsOfConstructor(
      @PathVariable("userId") int userId,
      @RequestParam(value = "sortBy", defaultValue = "createAt") String sortBy,
      //createAt, title, examineeCount, category
      @RequestParam(value = "order", defaultValue = "asc") String order,
      @RequestParam(value = "category", required = false) String category) {

    List<ExamVO> examVOList = examService.getExamList(userId, sortBy, order, category);

    return new ResponseEntity<>(CMResDTO.successDataRes(examVOList), HttpStatus.OK);
  }

  // 시험 상태 변경 (시작전, 진행중, 비활성화)
  @RequestMapping(value = "/{examId}/status", method = RequestMethod.PUT)
  public ResponseEntity<CMResDTO<String>> setExamStatus(@PathVariable("examId") int examId,
      @RequestParam("status") String status) {

    if (!status.equals("not_stated") && !status.equals("on_going") && !status.equals("closed")) {
      throw new IllegalArgumentException("유효하지 않은 파라미터입니다: " + status);
    }
    // on_going 상태에서 closed로 변경 -> 강제종료 : 현재 수험정보 전부 제출 처리
    if (status.equals("closed") && examMapper.getExamStatusById(examId).equals("on_going")) {
      // 먼저 WebSocket으로 "flush" 메시지 전송
      messageSendingOperations.convertAndSend("/topic/exam/" + examId + "/notifications",
              "시험이 곧 강제 종료됩니다! 브라우저에서 답안을 즉시 저장하세요. (3초 후 종료)");
      // 3초 정도 대기
      try {Thread.sleep(3000);} catch (InterruptedException e) {e.printStackTrace();}
      webSocketExamService.closeExam(examId);
    }

    examService.setExamStatus(examId, status);

    return new ResponseEntity<>(CMResDTO.successNoRes(), HttpStatus.OK);
  }

  //시험 삭제
  @RequestMapping(value = "/{examId}", method = RequestMethod.DELETE)
  public ResponseEntity<CMResDTO<String>> deleteExam(@PathVariable("examId") int examId) {

    examService.deleteExam(examId);

    return new ResponseEntity<>(CMResDTO.successNoRes(), HttpStatus.OK);
  }


  // 시험 초기 데이터 입력
  @PostMapping("/init")
  public ResponseEntity<CMResDTO<Integer>> createExam(
      @RequestBody ExamReqDTO examReqDTO) {

    int createrId = examReqDTO.getExamVO().getCreaterId();
    int examId = examService.createExam(examReqDTO, createrId);
    return new ResponseEntity<>(CMResDTO.successDataRes(examId), HttpStatus.OK);
  }

  // 시험 초기 데이터 수정
  @PutMapping("/init/{examId}")
  public ResponseEntity<CMResDTO<String>> updateExam(
      @PathVariable int examId,
      @RequestBody ExamVO examVO) {

    System.out.println(examVO);
    boolean success = examService.updateExam(examId, examVO);
    if (success) {
      return new ResponseEntity<>(CMResDTO.successDataRes("시험 수정 성공, " + examId), HttpStatus.OK);
    } else {
      return new ResponseEntity<>(CMResDTO.errorRes(ErrorCode.BAD_REQUEST), HttpStatus.BAD_REQUEST);
    }
  }

  // 문제 데이터 입력
  @PutMapping("/questions")
  public ResponseEntity<CMResDTO<String>> updateQuestion(
      @RequestParam int examId,
      @RequestBody List<QuestionVO> questions) {

    int updatedCount = examService.updateQuestions(examId, questions);

    return new ResponseEntity<>(CMResDTO.successDataRes("문제 등록 완료, 업데이트된 개수: " + updatedCount),
        HttpStatus.OK);
  }

  // 전체 문제 조회 (시험 아이디로)
  @GetMapping("/questions")
  public ResponseEntity<CMResDTO<List<QuestionVO>>> getExamQuestions(
      @RequestParam int examId) {
    List<QuestionVO> questions = examService.getExamQuestions(examId);
    return new ResponseEntity<>(CMResDTO.successDataRes(questions), HttpStatus.OK);
  }

  //시험 상태 확인
  @GetMapping("/{examId}/status")
  public ResponseEntity<CMResDTO<String>> getExamStatus(@PathVariable("examId") int examId) {
    String status = examService.getExamStatus(examId);
    return new ResponseEntity<>(CMResDTO.successDataRes(status), HttpStatus.OK);
  }

  // 기존 작성한 답안 불러오기
  @GetMapping("/exam-data/created")
  public ResponseEntity<CMResDTO<Map<String, Object>>> getExamDataForCreator(
      @RequestParam("examId") int examId,
      HttpSession session) {
    //todo 로그인 개발되면 사용
    //Integer creatorId = (Integer) session.getAttribute("userId");

    int creatorId = 1;

    Map<String, Object> examData = examService.getExamDataCreated(examId, creatorId);

    if (examData == null || examData.isEmpty()) {
      return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
          .body(
              (CMResDTO<Map<String, Object>>) (Object) CMResDTO.errorRes(ErrorCode.EXAM_NOT_FOUND));
    }
    return new ResponseEntity<>(CMResDTO.successDataRes(examData), HttpStatus.OK);
  }

  // 모든 시험 조회
  @GetMapping("/all")
  public List<ExamVO> getAllExams() {
    return examService.getAllExams();
  }

  // 시험명 검색
  @GetMapping("/search")
  public ResponseEntity<?> searchExams(@RequestParam(value = "name", required = false) String name) {
    List<ExamWithCreatorVO> examList = examService.searchExamsByName(name);

    return new ResponseEntity<>(CMResDTO.successDataRes(examList), HttpStatus.OK);
  }

  // 검색된 데이터에서 필터링만 수행
  @GetMapping("/filter")
  public ResponseEntity<?> searchExams(
      @RequestParam(value = "name", required = false) String name,
      @RequestParam(value = "category", required = false) String category,
      @RequestParam(value = "nickname", required = false) String nickname,
      @RequestParam(value = "createdAt", required = false) String createdAt,
      @RequestParam(value = "activationStatus", required = false) String activationStatus,
      @RequestParam(value = "examTime", required = false) Integer examTime,
      @RequestParam(value = "entreeCode", required = false) String entreeCode,
      @RequestParam(value = "examId", required = false) int examId){

    List<ExamVO> examList = examService.filterExam(name, category, creator, createdAt, activationStatus, examTime);
    return new ResponseEntity<>(CMResDTO.successDataRes(examList), HttpStatus.OK);
  }

  @PostMapping("/{examId}/close")
  public ResponseEntity<String> forceCloseExam(@PathVariable int examId) {
    webSocketExamService.closeExam(examId);
    return ResponseEntity.ok("시험이 강제 종료되었습니다.");
  }
  @GetMapping("/categories")
  public ResponseEntity<CMResDTO<List<String>>> searchCatgories() {

    List<String> categories = examService.searchCategories();

    return new ResponseEntity<>(CMResDTO.successDataRes(categories), HttpStatus.OK);
  }


}