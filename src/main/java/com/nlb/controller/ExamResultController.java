package com.nlb.controller;


import com.nlb.dto.response.ExamJoinResDTO;
import com.nlb.service.ExamResultService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import javax.servlet.http.HttpSession;


@Controller
@RequestMapping("/api/exams/results")
public class ExamResultController {

  @Autowired
  ExamResultService examResultService;


  // 시험에 응시 후, 응시 페이지로 리다이렉트
  @GetMapping("/join/{examId}")
  public String joinExam(
      @PathVariable("examId") int examId,
      @RequestParam("examCode") String examCode,
      @RequestParam("entreeCode") String entreeCode,
      HttpSession session) {

    int examineeId =
        (session.getAttribute("userId") != null) ? (int) session.getAttribute("userId") : 1;

    ExamJoinResDTO joinResponse = examResultService.joinExam(examId, examCode, examineeId,
        entreeCode);
    // 세션에 데이터 저장 (이후 API 요청에서 사용)
    session.setAttribute("examId", joinResponse.getExamId());
    session.setAttribute("examineeId", joinResponse.getExamineeId());

    System.out.println("joinExam() - 저장된 examId: " + joinResponse.getExamId());
    System.out.println("joinExam() - 저장된 examineeId: " + joinResponse.getExamineeId());

    return "redirect:/api/exams/results/exam/take";
  }

  @GetMapping("/exam/take")
  public String takeExam(HttpSession session, Model model) {
    Integer examId = (Integer) session.getAttribute("examId");
    //todo 들어온 세션과 지금 세션의 동일 체크 필요?
    System.out.println("examID 테스트  = " + examId);
    if (examId == null) {
      return "redirect:/exam-list"; // 시험 목록으로 리디렉트
    }

    model.addAttribute("examId", examId);
    return "jsp/exam/take_exam";
  }
}
