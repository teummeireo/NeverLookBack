package com.nlb.controller;


import com.nlb.command.StartCreateExamCommand;
import com.nlb.dto.request.ExamReqDTO;
import com.nlb.dto.response.CMResDTO;
import com.nlb.exception.ErrorCode;
import com.nlb.service.ExamService;
import com.nlb.vo.ExamMongoVO;
import com.nlb.vo.ExamVO;
import com.nlb.vo.QuestionVO;
import org.axonframework.commandhandling.gateway.CommandGateway;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping(value = "/api/exams")
public class ExamRestController {

    @Autowired
    private transient CommandGateway commandGateway;

    @Autowired
    private ExamService examService;

    // 정렬기능(제목, 생성일, 응시자수, 카테고리) & 필터기능(카테고리)
    @RequestMapping(value = "/{userId}", method = RequestMethod.GET)
    public ResponseEntity<CMResDTO<List<ExamVO>>> examsOfConstructor(
            @PathVariable("userId") int userId,
            @RequestParam(value = "sortBy", defaultValue = "createAt") String sortBy, //createAt, title, examineeCount, category
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


    @PostMapping("/init")
    public ResponseEntity<CMResDTO<Integer>> createExam(
            @RequestBody ExamReqDTO examReqDTO) {

        int examId = commandGateway.sendAndWait(new StartCreateExamCommand(examReqDTO));
        return new ResponseEntity<>(CMResDTO.successDataRes(examId), HttpStatus.OK);

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