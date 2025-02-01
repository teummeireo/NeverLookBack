package com.nlb.controller;


import net.bytebuddy.implementation.bytecode.constant.DefaultValue;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import java.time.LocalDateTime;

@Controller
@RequestMapping(value = "/admin")
public class AdminController {

    @RequestMapping(value = "/main", method = RequestMethod.GET)
    public String adminMain() {

        return "/jsp/admin/admin";
    }


    @RequestMapping(value = "/statistic/exams/{examId}", method = RequestMethod.GET)
    public ModelAndView adminStatisticExams(@PathVariable(value = "examId") int examId,
                                      @RequestParam(value = "creatAt", required = false) String createAt) {
                                        // 2025-01-22T00:00:00 폼으로 받아야함
       ModelAndView modelAndView = new ModelAndView();
       modelAndView.addObject("examId", examId);
       modelAndView.addObject("createAt", createAt);
       modelAndView.setViewName("jsp/admin/statistic/exams");

        return modelAndView;
    }

    @RequestMapping(value = "/statistic/site", method = RequestMethod.GET)
    public String adminStatisticSite() {

        return "/jsp/admin/statistic_site";
    }

    @RequestMapping(value = "/manage/users", method = RequestMethod.GET)
    public String adminManageUsers() {

        return "/jsp/admin/manage_user";

    }

    @RequestMapping(value = "/manage/exams", method = RequestMethod.GET)
    public String adminManageExamss() {

        return "/jsp/admin/manage_exams";

    }

}
