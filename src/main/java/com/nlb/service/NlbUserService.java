package com.nlb.service;


import com.nlb.vo.NlbUserVO;

import java.util.List;

public interface NlbUserService {


    List<NlbUserVO> getAllUsers();

    int setUserStatus(int userId, Boolean isActive);


    NlbUserVO getUser(int userId);

    int setUserDeactivate(NlbUserVO uvo);

    int updateUser(NlbUserVO uvo);
}
