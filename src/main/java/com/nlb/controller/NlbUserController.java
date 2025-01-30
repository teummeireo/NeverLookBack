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
import org.springframework.web.bind.annotation.RequestMethod;

@Controller
public class NlbUserController {

    @Autowired
    private NlbUserService nlbUserService;


    @RequestMapping(value = "/", method = RequestMethod.GET)
    public String main(HttpSession session) {

        //로그인 구현 안되서 하드코딩 합니다. todo: 하드코딩 지우기
        session.setAttribute("SESS_USERID"   , 1);
        session.setAttribute("SESS_NICKNAME" , "UserOne");

        return "/jsp/main";

    }



    @RequestMapping(value = "/mypage", method = RequestMethod.GET)
    public String mypage(Model model) {
        int userId = 1; // 임시 user_id

        // 서비스에서 사용자 정보 가져오기
        NlbUserVO user = nlbUserService.getUser(userId);

        // JSP에서 사용할 수 있도록 모델에 추가
        model.addAttribute("user", user);

        return "jsp/my_page";
    }

    @RequestMapping(value = "/edit-info", method = RequestMethod.GET)
    public String editInfo(HttpSession session) {


        return "/jsp/page_edit";

    }
}
