package com.nlb.controller;

import com.nlb.dto.response.CMResDTO;
import com.nlb.service.NlbUserService;
import com.nlb.vo.NlbUserVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.HttpRequestMethodNotSupportedException;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.List;


@RestController
@RequestMapping(value = "/api/users")
public class NlbUserRestController {

    @Autowired
    private NlbUserService nlbUserService;


    @PostMapping("/login")
    public ResponseEntity<String> login(HttpSession session) {
        session.setAttribute("userId", 1); // 세션에 userId 저장
        return new ResponseEntity<>("Login successful", HttpStatus.OK);
    }

    //회원 조회
    @RequestMapping(value = "/info/{userId}", method = RequestMethod.GET)
    public ResponseEntity<CMResDTO<NlbUserVO>> getUser(@PathVariable("userId") int userId) {

        NlbUserVO uvo = nlbUserService.getUser(userId);

        return new ResponseEntity<>(CMResDTO.successDataRes(uvo), HttpStatus.OK);
    }

    @RequestMapping(value = "/update", method = RequestMethod.PUT)
    public ResponseEntity<CMResDTO<String>> updateUser(@RequestBody NlbUserVO uvo) {

        int rows = nlbUserService.updateUser(uvo);


        return new ResponseEntity<>(CMResDTO.successNoRes(), HttpStatus.OK);
    }


    @RequestMapping(value = "/deactivate", method = RequestMethod.PUT)
    public ResponseEntity<CMResDTO<String>> setUserDeactivate(@RequestBody NlbUserVO uvo) {


        int rows = nlbUserService.setUserDeactivate(uvo);

        return new ResponseEntity<>(CMResDTO.successNoRes(), HttpStatus.OK);
    }


}
