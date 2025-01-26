package com.nlb.controller;


import com.nlb.dto.response.CMResDTO;
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

    // 정렬기능(점수, 응시일) & 필터기능(검토상태)
    @RequestMapping(value = "/{examId}", method = RequestMethod.GET)
    public ResponseEntity<CMResDTO<List<ExamResultVO>>> examResults(
            @PathVariable("examId") int examId,
            @RequestParam(value = "sortBy", defaultValue = "submittedAt") String sortBy,
            @RequestParam(value = "order", defaultValue = "asc") String order,
            @RequestParam(value = "isReviewed", required = false) boolean isReviewed) {

        List<ExamResultVO> examResultVOList = examResultService.getExamResultList(examId, sortBy, order, isReviewed);

        return new ResponseEntity<>(CMResDTO.successDataRes(examResultVOList), HttpStatus.OK);
    }

    // 시험 결과 검토 상태 변경
    @RequestMapping(value = "/{resultId}/status", method = RequestMethod.PUT)
    public ResponseEntity<CMResDTO<String>> setExamResultStatus(@PathVariable("resultId") int resultId,
                                                          @RequestParam("isReviewed") boolean isReviewed) {

        int rows = examResultService.setExamResultStatus(resultId, isReviewed);

        return new ResponseEntity<>(CMResDTO.successNoRes(), HttpStatus.OK);
    }


}
