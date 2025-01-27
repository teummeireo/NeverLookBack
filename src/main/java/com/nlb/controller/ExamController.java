package com.nlb.controller;


import com.mongodb.client.MongoClient;
import com.nlb.dto.response.CMResDTO;
import com.nlb.exception.ErrorCode;
import com.nlb.service.ExamService;
import com.nlb.vo.ExamMongoVO;
import com.nlb.vo.QuestionVO;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller
@RequestMapping("/api/exam")
public class ExamController {

  @Autowired
  private ExamService examService;
  @Autowired
  private MongoClient mongoClient;
  @Autowired
  private MongoTemplate mongoTemplate;

  @PostMapping("/init")
  public ResponseEntity<CMResDTO<String>> createExam(
      @RequestBody ExamMongoVO examMongoVO) {

    int examId = examService.createExam(examMongoVO);
    return new ResponseEntity<>(CMResDTO.successDataRes("시험 등록 성공, " + examId), HttpStatus.OK);
  }

  @PutMapping("/init/{examId}")
  public ResponseEntity<CMResDTO<String>> updateExam(
      @PathVariable int examId,
      @RequestBody ExamMongoVO examMongoVO) {

    boolean success = examService.updateExam(examId, examMongoVO);
    if (success) {
      return new ResponseEntity<>(CMResDTO.successDataRes("시험 수정 성공, " + examId), HttpStatus.OK);
    } else {
      return new ResponseEntity<>(CMResDTO.errorRes(ErrorCode.BAD_REQUEST), HttpStatus.BAD_REQUEST);
    }
  }

  @PutMapping("/{examId}/questions")
  public ResponseEntity<CMResDTO<String>> updateQuestion(
      @PathVariable int examId,
      @RequestBody List<QuestionVO> questions) {

    boolean success = examService.updateQuestions(examId, questions);
    if (success) {
      return new ResponseEntity<>(CMResDTO.successDataRes("문제 등록 성공, "), HttpStatus.OK);
    } else {
      return new ResponseEntity<>(CMResDTO.errorRes(ErrorCode.BAD_REQUEST), HttpStatus.BAD_REQUEST);
    }
  }


}
//