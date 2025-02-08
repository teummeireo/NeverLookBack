package com.nlb.controller;


import com.nlb.dto.response.ExamJoinResDTO;
import com.nlb.service.ExamResultService;
import javax.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;


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
      HttpSession session, Model model) {

    int examineeId =
        (session.getAttribute("userId") != null) ? (int) session.getAttribute("userId") : 1;
    //Integer examineeId = (Integer) session.getAttribute("userId");

    // ExamJoinResDTO에서 응시 정보를 가져옴
    ExamJoinResDTO joinResponse = examResultService.joinExam(examId, examCode, examineeId,
        entreeCode);

    if (joinResponse == null) {
      model.addAttribute("errorMessage", "시험에 응시할 수 없습니다. 요청 정보를 확인하세요.");
      return "error/error-page"; // 에러 페이지로 이동
    }

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
    Integer examineeId = (Integer) session.getAttribute("userId");

    if (examId == null || examineeId == null) {
      model.addAttribute("errorMessage", "시험 정보가 없습니다. 다시 시도하세요.");
      return "redirect:/exam/list";
    }

    model.addAttribute("examId", examId);
    model.addAttribute("examineeId", examineeId);

    return "/jsp/exam/take_exam"; // 실제 JSP 파일 경로
  }

  @GetMapping("/{examId}/lists")
  public String resultList(@PathVariable("examId") int examId, Model model) {
    model.addAttribute("examId", examId);
    return "jsp/exam/exam_creater/submission_check";
  }

  @GetMapping("/{examId}/detail")
  public String resultDetail(@PathVariable("examId") int examId,
      @RequestParam("resultId") int resultId,
      @RequestParam("examineeId") int examineeId,
      Model model) {

    model.addAttribute("examId", examId);
    model.addAttribute("resultId", resultId);
    model.addAttribute("examineeId", examineeId);
    return "jsp/exam/exam_creater/created_exam_detail"; // 완성본으로 경로 수정
  }

  @GetMapping("/my")
  public String myResult(Model model, HttpSession session) {
    int userId = (Integer) session.getAttribute("userId");
    System.out.println("세션에서 가져온 유저 아이디 =  " + userId);
    model.addAttribute("userId", userId);
    return "jsp/exam/exam_result";
  }

  @GetMapping("/creator/detail")
  public String CreatedExamDetail(
      @RequestParam("examId") int examId,
      @RequestParam("examineeId") int examineeId,
      Model model) {

    model.addAttribute("examId", examId);
    model.addAttribute("examineeId", examineeId);
    return "jsp/exam/exam_creater/created_exam_detail";
  }

  @GetMapping("/my_exam_detail")
  public String myExamDetail(
      @RequestParam("examId") int examId,
      @RequestParam("examineeId") int examineeId,
      @RequestParam("resultId") int resultId,
      Model model) {
    System.out.println("입력값 체크 " + examId + " examineeid" + examineeId + "result" + resultId);

    model.addAttribute("examId", examId);
    model.addAttribute("examineeId", examineeId);
    model.addAttribute("resultId", resultId);

    return "jsp/exam/my_exam_detail";
  }

}
