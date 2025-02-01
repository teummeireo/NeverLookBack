package com.nlb.controller;


import javax.servlet.http.HttpSession;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import com.nlb.service.NlbUserService;
import com.nlb.vo.NlbUserVO;
import java.util.HashMap;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

@Controller
public class NlbUserController {

    @Autowired
    private NlbUserService nlbUserService;


    @RequestMapping(value = "/", method = RequestMethod.GET)
    public String main(HttpSession session) {

        //로그인 구현 안되서 하드코딩 합니다. todo: 하드코딩 지우기
        session.setAttribute("SESS_USERID"   , 8);
        session.setAttribute("SESS_NICKNAME" , "UserOne");

        return "/jsp/main";

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


}
