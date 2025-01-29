package com.nlb.controller;


import javax.servlet.http.HttpSession;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import com.nlb.service.NlbUserService;
import com.nlb.vo.NlbUserVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/api/users")
public class NlbUserController {

  @PostMapping("/login")
  public ResponseEntity<String> login(HttpSession session) {
    session.setAttribute("userId", 1); // 세션에 userId 저장
    return new ResponseEntity<>("Login successful", HttpStatus.OK);
  }

    @Autowired
    private NlbUserService nlbUserService;

    @GetMapping("/my_page")
    public String getUserInfo(Model model) {
        int userId = 1; // 임시 user_id

        // 서비스에서 사용자 정보 가져오기
        NlbUserVO user = nlbUserService.getUser(userId);

        // JSP에서 사용할 수 있도록 모델에 추가
        model.addAttribute("user", user);

        return "jsp/my_page";
    }
}
