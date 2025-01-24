package com.nlb.service;


import com.nlb.mapper.NlbUserMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class NlbUserServiceImpl implements NlbUserService {

    @Autowired
    private NlbUserMapper userMapper; // DB와 상호작용하는 Repository

    @Override
    public boolean isUniqueId(String id) {
        // Repository를 사용하여 ID 중복 여부 확인
        return !userMapper.existsById(id); // 존재하지 않으면 고유(true)
    }
}
