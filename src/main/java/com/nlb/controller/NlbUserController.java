package com.nlb.controller;


import javax.servlet.http.HttpSession;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;

@Controller
public class NlbUserController {

  @PostMapping("/login")
  public ResponseEntity<String> login(HttpSession session) {
    session.setAttribute("userId", 1); // 세션에 userId 저장
    return new ResponseEntity<>("Login successful", HttpStatus.OK);
  }

}
