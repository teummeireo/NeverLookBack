package com.nlb.controller;


import com.nlb.dto.response.CMResDTO;
import com.nlb.service.ExamService;
import com.nlb.vo.ExamVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;


import java.util.List;

@RestController
@RequestMapping(value = "/api/exams")
public class ExamRestController {

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
}