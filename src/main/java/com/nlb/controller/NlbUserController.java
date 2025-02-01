package com.nlb.controller;

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

@Controller
@RequestMapping("/api/users")
public class NlbUserController {

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
