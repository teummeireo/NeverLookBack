package com.nlb.controller;


import com.nlb.service.NlbUserService;
import com.nlb.vo.NlbUserVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@Controller
public class NlbUserController {

    @Autowired
    private NlbUserService nlbUserService;


    @RequestMapping(value = "/", method = RequestMethod.GET)
    public String main(HttpSession session) {

        return "/jsp/new_main";

    }

    @RequestMapping(value = "/login", method = RequestMethod.GET)
    public String login(HttpSession session) {
        // 로그인 성공 후 세션에 userId가 있다면 메인 페이지로 리다이렉트
        if (session.getAttribute("userId") != null) {
            return "redirect:/jsp/new_main";
        }
        return "/jsp/login_info/login"; // 로그인 페이지로 이동
    }

    @RequestMapping(value = "/logout", method = RequestMethod.GET)
    public String Logout(HttpSession session, HttpServletResponse response) {
        Cookie sessionCookie = new Cookie("SESSIONID", session.getId());
        sessionCookie.setHttpOnly(true); // 클라이언트 스크립트에서 접근 불가
        sessionCookie.setPath("/"); // 루트 경로에 대해 유효
        sessionCookie.setMaxAge(0);
        response.addCookie(sessionCookie);

        session.invalidate();
        session.setMaxInactiveInterval(0);


        response.setHeader("Expires", "0");
        response.setHeader("Pragma", "no-cache");
        response.setHeader("Cache-Control", "private, no-cache, no-store, must-revalidate"); //정적 리소스는 캐싱 가능, 민감한 데이터는 캐싱 비활성화.

        return "redirect:/";
    }

    @RequestMapping(value = "/find_id", method = RequestMethod.GET)
    public String findId(HttpSession session) {

        return "/jsp/login_info/find_id";

    }

    @RequestMapping(value = "/find_pw", method = RequestMethod.GET)
    public String findPw(HttpSession session) {

        return "/jsp/login_info/find_pw";

    }

    @RequestMapping(value = "/register", method = RequestMethod.GET)
    public String register(HttpSession session) {

        return "/jsp/register";

    }


    @RequestMapping(value = "/mypage", method = RequestMethod.GET)
    public ModelAndView mypage(ModelAndView modelAndView) {
        int userId = 1; // 임시 user_id

        // 서비스에서 사용자 정보 가져오기
        NlbUserVO user = nlbUserService.getUser(userId);

        // JSP에서 사용할 수 있도록 모델에 추가
        modelAndView.addObject("userVO", user);
        modelAndView.setViewName("jsp/my_page");

        return modelAndView;
    }

    @RequestMapping(value = "/edit-info", method = RequestMethod.GET)
    public String editInfo() {


        return "/jsp/page_edit";

    }

    @RequestMapping(value = "/unregister", method = RequestMethod.GET)
    public String unregister() {


        return "/jsp/unregister_user";

    }


    @GetMapping("/my-result")
    public String myResult(Model model) {
        return "/jsp/exam/my_exam";
    } 
     

    @RequestMapping(value = "/exam_search", method = RequestMethod.GET)
    public String examSearch() {

        return "/jsp/exam_search";
    }


}
