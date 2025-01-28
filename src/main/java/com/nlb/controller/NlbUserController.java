package com.nlb.controller;

import com.nlb.service.NlbUserService;
import com.nlb.vo.NlbUserVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/api/users")
public class NlbUserController {

    @Autowired
    private NlbUserService nlbUserService;

    // /my_page 경로에 대한 매핑
    @GetMapping("/my_page")
    public String myPage(Model model) {
        // userId는 하드코딩 또는 세션에서 가져올 수 있습니다.
        int userId = 1;  // 임시로 userId를 1로 설정

        NlbUserVO user = nlbUserService.getUser(userId);  // 유저 정보 가져오기
        model.addAttribute("user", user);  // 유저 정보를 JSP로 전달
        return "my_page";  // 'my_page.jsp'로 이동
    }

    // /api/users/info/{userId} 경로에 대한 매핑
    @GetMapping("/api/users/info/{userId}")
    public String getUserInfo(@PathVariable("userId") int userId, Model model) {
        NlbUserVO user = nlbUserService.getUser(userId);  // 유저 정보 가져오기
        model.addAttribute("user", user);  // 유저 정보를 JSP로 전달
        return "my_page";  // 'my_page.jsp'로 이동
    }
}