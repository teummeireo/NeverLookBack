package com.nlb.controller;


import com.nlb.dto.request.ExamResultReqDTO;
import com.nlb.dto.response.CMResDTO;
import com.nlb.dto.response.ExamDataResDTO;
import com.nlb.dto.response.ExamJoinResDTO;
import com.nlb.dto.response.ExamResultCardDTO;
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

  // 시험 결과 카드 데이터 조회

  @RequestMapping(value = "/{resultId}/card", method = RequestMethod.GET)
  public ResponseEntity<CMResDTO<ExamResultCardDTO>> examResultCard(
      @PathVariable("resultId") int resultId) {
    ExamResultCardDTO examResultCardDTO = examResultService.getExamResultAndExam(resultId);
    return new ResponseEntity<>(CMResDTO.successDataRes(examResultCardDTO), HttpStatus.OK);
  }


  // 시험 제출
  @PostMapping("/{resultId}/submit")
  public ResponseEntity<CMResDTO<List<AnswerVO>>> submitExam(
      @PathVariable int resultId,
      @RequestBody ExamResultReqDTO examResultReqDTO) {

    //todo 세션으로 아이디 가져오기
    int examineeId = 1;
    List<AnswerVO> savedAnswers = examResultService.submitExam(examineeId, examResultReqDTO);

    return new ResponseEntity<>(CMResDTO.successDataRes(savedAnswers), HttpStatus.OK);
  }


  //시험 응답 저장
  @PostMapping("/{resultId}/answers")
  public ResponseEntity<CMResDTO<String>> saveExamAnswers(
      @PathVariable int resultId,
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
      @RequestParam String examCode,
      @RequestParam String entreeCode) {
    //Integer examineeId = (Integer) session.getAttribute("userId");
    //todo 로그인 개발되면 세션으로 변경
    int examineeId = 1;
    ExamJoinResDTO response = examResultService.joinExam(examCode, examineeId, entreeCode);

    return new ResponseEntity<>(CMResDTO.successDataRes(response), HttpStatus.OK);
  }

  @GetMapping("/{examId}/{examineeId}")
  public ResponseEntity<CMResDTO<Map<String, Object>>> getExamData(
      @PathVariable("examId") int examId,
      @PathVariable("examineeId") int examineeId
  ) {
    Map<String, Object> resultData = examResultService.getExamResultData(examId, examineeId);
    return new ResponseEntity<>(CMResDTO.successDataRes(resultData), HttpStatus.OK);
  }

  //시험
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


}

