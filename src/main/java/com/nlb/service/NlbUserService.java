package com.nlb.service;


import com.nlb.vo.NlbUserVO;

import java.util.List;

public interface NlbUserService {


    List<NlbUserVO> getAllUsers();

    int setUserStatus(int userId, Boolean isActive);


    NlbUserVO getUser(int userId);

    int setUserDeactivate(int userId);

    int updateUser(NlbUserVO uvo);

    // 회원가입 관련
    boolean isLoginIdExist(String loginId);
    boolean isNicknameExist(String nickname);
    int registerUser(NlbUserVO uvo);

    // 이메일 관련
    boolean isEmailExist(String email);



}
