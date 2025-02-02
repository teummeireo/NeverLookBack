package com.nlb.controller;


import com.nlb.dto.request.ExamReqDTO;
import com.nlb.dto.response.CMResDTO;
import com.nlb.exception.ErrorCode;
import com.nlb.service.ExamResultService;
import com.nlb.service.ExamService;
import com.nlb.vo.ExamVO;
import com.nlb.vo.QuestionVO;
import java.util.List;
import java.util.Map;
import javax.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping(value = "/api/exams")
public class ExamRestController {

  @Autowired
  private ExamService examService;
  @Autowired
  private ExamResultService examResultService;

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
    int rows = examService.setExamStatus(examId, status);

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
  public ResponseEntity<CMResDTO<String>> createExam(
      @RequestBody ExamReqDTO examReqDTO) {

    int createrId = 1;  //todo 로그인 완료되면 세션 아이디 등록

    int examId = examService.createExam(examReqDTO, createrId);
    return new ResponseEntity<>(CMResDTO.successDataRes("시험 등록 성공, " + examId), HttpStatus.OK);
  }

  // 시험 초기 데이터 수정
  @PutMapping("/init/{examId}")
  public ResponseEntity<CMResDTO<String>> updateExam(
      @PathVariable int examId,
      @RequestBody ExamVO examVO) {

    boolean success = examService.updateExam(examId, examVO);
    if (success) {
      return new ResponseEntity<>(CMResDTO.successDataRes("시험 수정 성공, " + examId), HttpStatus.OK);
    } else {
      return new ResponseEntity<>(CMResDTO.errorRes(ErrorCode.BAD_REQUEST), HttpStatus.BAD_REQUEST);
    }
  }

  // 문제 데이터 입력
  @PutMapping("/{examId}/questions")
  public ResponseEntity<CMResDTO<String>> updateQuestion(
      @PathVariable int examId,
      @RequestBody List<QuestionVO> questions) {

    int updatedCount = examService.updateQuestions(examId, questions);

    return new ResponseEntity<>(CMResDTO.successDataRes("문제 등록 완료, 업데이트된 개수: " + updatedCount),
        HttpStatus.OK);
  }

  // 전체 문제 조회 (시험 아이디로)
  @GetMapping("/{examId}/questions")
  public ResponseEntity<CMResDTO<List<QuestionVO>>> getExamQuestions(
      @PathVariable("examId") int examId) {
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

  // 시험명 검색
  @GetMapping("/search")
  public ResponseEntity<?> searchExams(@RequestParam(value = "name", required = false) String name) {
    List<ExamVO> examList = examService.searchExamsByName(name);

    return new ResponseEntity<>(CMResDTO.successDataRes(examList), HttpStatus.OK);
  }

}