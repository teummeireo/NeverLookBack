package com.nlb.controller;


import com.nlb.dto.request.ExamResultReqDTO;
import com.nlb.dto.response.CMResDTO;
import com.nlb.dto.response.ExamDataResDTO;
import com.nlb.dto.response.ExamJoinResDTO;
import com.nlb.dto.response.ExamResultCardDTO;
import com.nlb.dto.response.ExamineeInfoResDTO;
import com.nlb.exception.ErrorCode;
import com.nlb.service.ExamResultService;
import com.nlb.vo.AnswerVO;
import com.nlb.vo.ExamResultVO;
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
@RequestMapping(value = "/api/exams/results")
public class ExamResultRestController {

  @Autowired
  private ExamResultService examResultService;


  // 내가 만든 시험의 응시 내역 조회
  // 정렬기능(점수, 응시일) & 필터기능(검토상태)
  @RequestMapping(value = "/{examId}", method = RequestMethod.GET)
  public ResponseEntity<CMResDTO<List<ExamResultVO>>> examResults(
          @PathVariable("examId") int examId,
          @RequestParam(value = "sortBy", defaultValue = "submittedAt") String sortBy,
          //score, submittedAt
          @RequestParam(value = "order", defaultValue = "asc") String order,
          @RequestParam(value = "isReviewed", required = false) Boolean isReviewed) {

    List<ExamResultVO> examResultVOList = examResultService.getExamResultList(examId, sortBy, order,
            isReviewed);

    return new ResponseEntity<>(CMResDTO.successDataRes(examResultVOList), HttpStatus.OK);
  }

  // 시험 결과 검토 상태 변경
  @RequestMapping(value = "/{resultId}/status", method = RequestMethod.PUT)
  public ResponseEntity<CMResDTO<String>> setExamResultStatus(
          @PathVariable("resultId") int resultId,
          @RequestParam("isReviewed") Boolean isReviewed) {

    int rows = examResultService.setExamResultStatus(resultId, isReviewed);

    return new ResponseEntity<>(CMResDTO.successNoRes(), HttpStatus.OK);
  }


  // 내가 본 시험 결과들 조회
  // 정렬기능(점수, 응시일) & 필터기능(검토상태)
  @RequestMapping(value = "/user/{userId}", method = RequestMethod.GET)
  public ResponseEntity<CMResDTO<List<ExamResultVO>>> examResultsOfUser(
          @PathVariable("userId") int userId,
          @RequestParam(value = "sortBy", defaultValue = "submittedAt") String sortBy,
          //score, submittedAt, category
          @RequestParam(value = "order", defaultValue = "asc") String order,
          @RequestParam(value = "isReviewed", required = false) Boolean isReviewed) {

    List<ExamResultVO> examResultVOList = examResultService.getExamResultListOfUser(userId, sortBy,
            order, isReviewed);

    return new ResponseEntity<>(CMResDTO.successDataRes(examResultVOList), HttpStatus.OK);
  }

  @GetMapping
  public ResponseEntity<CMResDTO<List<ExamResultVO>>> getAllResults() {
    List<ExamResultVO> results = examResultService.getAllExamResults(); // 모든 데이터 가져오기
    return ResponseEntity.ok(new CMResDTO<>(1, "전체 시험 결과 조회 성공", results));
  }

  // 시험 결과 카드 데이터 조회
  @RequestMapping(value = "/{resultId}/card", method = RequestMethod.GET)
  public ResponseEntity<CMResDTO<ExamResultCardDTO>> examResultCard(
          @PathVariable("resultId") int resultId) {
    ExamResultCardDTO examResultCardDTO = examResultService.getExamResultAndExam(resultId);
    return new ResponseEntity<>(CMResDTO.successDataRes(examResultCardDTO), HttpStatus.OK);
  }


  // 시험 제출
  @PostMapping("/{examId}/submit")
  public ResponseEntity<CMResDTO<List<AnswerVO>>> submitExam(
          @RequestBody ExamResultReqDTO examResultReqDTO) {

    //todo 세션으로 아이디 가져오기
    int examineeId = 1;
    List<AnswerVO> savedAnswers = examResultService.submitExam(examineeId, examResultReqDTO);

    return new ResponseEntity<>(CMResDTO.successDataRes(savedAnswers), HttpStatus.OK);
  }


  //시험 응답 저장
  @PostMapping("/{resultId}/answers")
  public ResponseEntity<CMResDTO<String>> saveExamAnswers(
          @RequestBody ExamResultReqDTO examResultReqDTO) {

    //todo 세션으로 아이디 가져오기
    int examineeId = 1;
    int summitCount = examResultService.saveExamAnswers(examineeId, examResultReqDTO);

    return new ResponseEntity<>(CMResDTO.successDataRes("응답 저장 완료 개수" + summitCount),
            HttpStatus.OK);
  }

  //시험 입장
  @PostMapping("/{examId}/join")
  public ResponseEntity<CMResDTO<ExamJoinResDTO>> joinExam(
          @PathVariable int examId,
          @RequestParam String examCode,
          @RequestParam String entreeCode) {
    //Integer examineeId = (Integer) session.getAttribute("userId");
    //todo 로그인 개발되면 세션으로 변경
    int examineeId = 1;
    ExamJoinResDTO response = examResultService.joinExam(examId, examCode, examineeId, entreeCode);

    return new ResponseEntity<>(CMResDTO.successDataRes(response), HttpStatus.OK);
  }


  // 제출 답안 상세 조회
  @GetMapping("/{examId}/answers")
  public ResponseEntity<CMResDTO<Map<String, Object>>> getExamData(
          @PathVariable("examId") int examId,
          @RequestParam(value = "examineeId", required = false) Integer examineeId,
          HttpSession session
  ) {
    // 파라미터 없이 들어오면 세션으로 내 조회  vs  파라미터 있으면 해당 아이디 조회
    int ExamineeId = (examineeId != null) ? examineeId : (Integer) session.getAttribute("userId");

    //todo 로그인 개발되면 세션으로 변경
    //ExamineeId = 1;

    Map<String, Object> resultData = examResultService.getExamResultData(examId, ExamineeId);
    return new ResponseEntity<>(CMResDTO.successDataRes(resultData), HttpStatus.OK);
  }

  //시험 입장 후 데이터 조회 ( 문제 + 내가 입력한 답안 )
  @GetMapping("/{examId}/exam-data")
  public ResponseEntity<CMResDTO<ExamDataResDTO>> getExamDataForUser(
          @PathVariable("examId") int examId,
          HttpSession session) {
    //todo 로그인 개발되면 사용
    //Integer examineeId = (Integer) session.getAttribute("userId");

    int examineeId = 1;

    ExamDataResDTO examData = examResultService.getExamData(examId, examineeId);
    return new ResponseEntity<>(CMResDTO.successDataRes(examData), HttpStatus.OK);
  }


  //
  @GetMapping("/{examId}/{resultId}/details")
  public ResponseEntity<CMResDTO<ExamResultVO>> getResultDetail(
          @PathVariable("examId") int examId,
          @PathVariable("resultId") int resultId) {

    //todo 로그인 개발되면 세션으로 변경
    int examineeId = 1;

    // 시험 결과 조회
    ExamResultVO examResultVO = examResultService.getResultDetail(examineeId, examId, resultId);

    return new ResponseEntity<>(CMResDTO.successDataRes(examResultVO), HttpStatus.OK);
  }


  // 각 문제에 대한 채점/이의제기 상태 표기
  @GetMapping("/details")
  public ResponseEntity<CMResDTO<List<Map<String, Object>>>> getResultDetails(
          @RequestParam("examId") int examId,
          @RequestParam("examineeId") int examineeId){

    List<Map<String, Object>> questionsState = examResultService.getQuestionsState(examId, examineeId);

    return ResponseEntity.ok(CMResDTO.successDataRes(questionsState));
  }




  //응시자 정보 조회
  @GetMapping("/examinee-info")
  public ResponseEntity<CMResDTO<ExamineeInfoResDTO>> getExamineeInfo(
          @RequestParam int examId,
          @RequestParam int examineeId) {
    ExamineeInfoResDTO response = examResultService.getExamineeInfo(examId, examineeId);
    return ResponseEntity.ok(CMResDTO.successDataRes(response));
  }

  //이의제기 등록
  @PutMapping("/{examId}/dispute/{questionId}")
  public ResponseEntity<CMResDTO<String>> submitObjection(
          @PathVariable int examId,
          @PathVariable int questionId,
          @RequestBody Map<String, String> requestBody) {

    int examineeId = 1; //todo 로그인 개발되면 세션으로 변경
    boolean success = examResultService.submitObjection(examId, examineeId, questionId,
            requestBody.get("objection"));

    if (success) {
      return new ResponseEntity<>(CMResDTO.successDataRes("이의제기 성공"), HttpStatus.OK);
    } else {
      return new ResponseEntity<>(CMResDTO.errorRes(ErrorCode.BAD_REQUEST), HttpStatus.BAD_REQUEST);
    }
  }

  //이의제기 답변 등록
  @PutMapping("/{examId}/disputeReply/{questionId}")
  public ResponseEntity<CMResDTO<String>> submitObjectionReply(
          @PathVariable int examId,
          @PathVariable int questionId,
          @RequestBody Map<String, String> requestBody) {  // JSON에서 reply 추출

    int examineeId = 1; // TODO: 로그인 개발되면 세션에서 가져오기
    boolean success = examResultService.submitObjectionReply(examId, examineeId, questionId,
            requestBody.get("objectionReply"));

    if (success) {
      return new ResponseEntity<>(CMResDTO.successDataRes("이의제기 답변 등록 성공"), HttpStatus.OK);
    } else {
      return new ResponseEntity<>(CMResDTO.errorRes(ErrorCode.BAD_REQUEST), HttpStatus.BAD_REQUEST);
    }
  }


  //점수 수정 (객관식)
  @PutMapping("/updateObj")
  public ResponseEntity<CMResDTO<String>> updateQuestionScore(
          @RequestParam int resultId,
          @RequestParam int questionId,
          @RequestParam boolean isCorrected)
  {

    boolean success = examResultService.updateQuestionScore(resultId, questionId, isCorrected);

    if (success) {
      return new ResponseEntity<>(CMResDTO.successDataRes("문제 수정 성공"), HttpStatus.OK);
    } else {
      return new ResponseEntity<>(CMResDTO.errorRes(ErrorCode.BAD_REQUEST), HttpStatus.BAD_REQUEST);
    }
  }
}


