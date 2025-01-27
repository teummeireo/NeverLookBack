package com.nlb.service;


import com.nlb.vo.NlbUserVO;

import java.util.List;

public interface NlbUserService {
    boolean isUniqueId(String id);

    List<NlbUserVO> getAllUsers();

    int setUserStatus(int userId, Boolean isActive);
}
