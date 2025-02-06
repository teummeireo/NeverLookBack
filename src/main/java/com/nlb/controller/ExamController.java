package com.nlb.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
@RequestMapping("/api/exams")
public class ExamController {

  @GetMapping("/init-exam")
  public String initExamPage(Model model) {
    return "jsp/exam/init_exam";

  }

  @GetMapping("/create-exam")
  public String showCreateExamPage(@RequestParam("examId") int examId, Model model) {
    model.addAttribute("examId", examId);
    return "jsp/exam/create_exam";

  }

}
