package com.nlb.controller;


import com.nlb.dto.response.CMResDTO;
import com.nlb.service.ExamService;
import com.nlb.service.NlbUserService;
import com.nlb.vo.ExamVO;
import com.nlb.vo.NlbUserVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping(value = "/api/admin")
public class AdminRestController {

    @Autowired
    private ExamService examService;

    @Autowired
    NlbUserService nlbUserService;

    @RequestMapping(value = "/users", method = RequestMethod.GET)
    public ResponseEntity<CMResDTO<List<NlbUserVO>>> getAllUsers() {

        List<NlbUserVO> ulist = nlbUserService.getAllUsers();

        return new ResponseEntity<>(CMResDTO.successDataRes(ulist), HttpStatus.OK);
    }

    // 유저 비활성화
    @RequestMapping(value = "/users/{userId}", method = RequestMethod.PUT)
    public ResponseEntity<CMResDTO<String>> setUserStatus(@PathVariable("userId") int userId,
                                                          @RequestParam("isActive") Boolean isActive) {


        int rows = nlbUserService.setUserStatus(userId, isActive);

        return new ResponseEntity<>(CMResDTO.successNoRes(), HttpStatus.OK);
    }


    @RequestMapping(value = "/users/role/{userId}", method = RequestMethod.PUT)
    public ResponseEntity<CMResDTO<String>> setUserRole(@PathVariable("userId") int userId,
                                                          @RequestParam("role") String role) {


        int rows = nlbUserService.setUserRole(userId, role);
        System.out.println("gdgdg");
        return new ResponseEntity<>(CMResDTO.successNoRes(), HttpStatus.OK);
    }

    // 정렬기능(제목, 생성일, 응시자수, 카테고리) & 필터기능(카테고리)
    @RequestMapping(value = "/exams", method = RequestMethod.GET)
    public ResponseEntity<CMResDTO<List<ExamVO>>> getAllExams(
            @RequestParam(value = "sortBy", defaultValue = "createAt") String sortBy, //createAt, title, examineeCount, category
            @RequestParam(value = "order", defaultValue = "asc") String order,
            @RequestParam(value = "category", required = false) String category) {

        List<ExamVO> examVOList = examService.getAllExams(sortBy, order, category);

        return new ResponseEntity<>(CMResDTO.successDataRes(examVOList), HttpStatus.OK);
    }

}
