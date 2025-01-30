package com.nlb.controller;


import com.nlb.dto.response.CMResDTO;
import com.nlb.dto.response.ExamResultCardDTO;
import com.nlb.service.ExamResultService;
import com.nlb.service.NlbUserService;
import com.nlb.vo.ExamResultVO;
import com.nlb.vo.ExamVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;

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
            @RequestParam(value = "sortBy", defaultValue = "submittedAt") String sortBy, //score, submittedAt
            @RequestParam(value = "order", defaultValue = "asc") String order,
            @RequestParam(value = "isReviewed", required = false) Boolean isReviewed) {

        List<ExamResultVO> examResultVOList = examResultService.getExamResultList(examId, sortBy, order, isReviewed);

        return new ResponseEntity<>(CMResDTO.successDataRes(examResultVOList), HttpStatus.OK);
    }

    @GetMapping
    public ResponseEntity<CMResDTO<List<ExamResultVO>>> getAllResults() {
        List<ExamResultVO> results = examResultService.getAllExamResults(); // 모든 데이터 가져오기
        return ResponseEntity.ok(new CMResDTO<>(1, "전체 시험 결과 조회 성공", results));
    }

    // 시험 결과 검토 상태 변경
    @RequestMapping(value = "/{resultId}/status", method = RequestMethod.PUT)
    public ResponseEntity<CMResDTO<String>> setExamResultStatus(@PathVariable("resultId") int resultId,
                                                          @RequestParam("isReviewed") Boolean isReviewed) {

        int rows = examResultService.setExamResultStatus(resultId, isReviewed);

        return new ResponseEntity<>(CMResDTO.successNoRes(), HttpStatus.OK);
    }


    // 내가 본 시험 결과들 조회
    // 정렬기능(점수, 응시일) & 필터기능(검토상태)
    @RequestMapping(value = "/user/{userId}", method = RequestMethod.GET)
    public ResponseEntity<CMResDTO<List<ExamResultVO>>> examResultsOfUser(
            @PathVariable("userId") int userId,
            @RequestParam(value = "sortBy", defaultValue = "submittedAt") String sortBy, //score, submittedAt, category
            @RequestParam(value = "order", defaultValue = "asc") String order,
            @RequestParam(value = "isReviewed", required = false) Boolean isReviewed) {

        List<ExamResultVO> examResultVOList = examResultService.getExamResultListOfUser(userId, sortBy, order, isReviewed);

        return new ResponseEntity<>(CMResDTO.successDataRes(examResultVOList), HttpStatus.OK);
    }

    // 시험 결과 카드 데이터 조회

    @RequestMapping(value = "/{resultId}/card", method = RequestMethod.GET)
    public ResponseEntity<CMResDTO<ExamResultCardDTO>> examResultCard(@PathVariable("resultId") int resultId){
        ExamResultCardDTO examResultCardDTO = examResultService.getExamResultAndExam(resultId);
        return new ResponseEntity<>(CMResDTO.successDataRes(examResultCardDTO), HttpStatus.OK);
    }

}
