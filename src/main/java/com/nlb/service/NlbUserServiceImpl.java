package com.nlb.service;


import com.nlb.exception.BadRequestException;
import com.nlb.mapper.NlbUserMapper;
import com.nlb.util.PasswordUtil;
import com.nlb.vo.NlbUserVO;
import javax.transaction.Transactional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

import static com.nlb.exception.ErrorCode.USER_MODIFY_PASSWORD_FAILURE;

@Service
public class NlbUserServiceImpl implements NlbUserService {

    @Autowired
    private NlbUserMapper userMapper; // DB와 상호작용하는 Repository



    @Override
    public List<NlbUserVO> getAllUsers() {
        return userMapper.selectUsers();
    }

    @Override
    public int setUserStatus(int userId, Boolean isActive) {
        return userMapper.updateUserIsActive(userId, isActive);
    }

    @Override
    public NlbUserVO getUser(int userId) {
        return userMapper.selectUserByUserId(userId);
    }

    @Override
    public int setUserDeactivate(int userId) {
        return userMapper.updateUserDeactivate(userId);
    }

    @Override
    public int updateUser(NlbUserVO uvo) {

        // 닉네임 중복 확인 로직 => uvo.nickname이 null 일경우 변경하지 않는 것이므로 체크 안함
        if(uvo.getNickname() != null && !uvo.getNickname().equals("")) {
            String oldNickname = userMapper.selectNicknameByUserId(uvo.getUserId());
            if (oldNickname.equals(uvo.getNickname())) {
                throw new IllegalArgumentException("기존 닉네임과 다른 닉네임을 입력해주세요");
            }
        } else {
            uvo.setNickname(null);
        }

        // 비밀번호가 기존과 일치하는지 확인하는 로직
        if(uvo.getPassword() != null && !uvo.getPassword().equals("")) {
            String oldPassword = userMapper.selectPasswordByUserId(uvo.getUserId());
            String plainPassword = uvo.getPassword();
            if(PasswordUtil.checkPassword(plainPassword, oldPassword)) {
                throw new BadRequestException(USER_MODIFY_PASSWORD_FAILURE);
            }
            String hashedPassword = PasswordUtil.hashPassword(plainPassword);
            uvo.setPassword(hashedPassword);
        } else {
            uvo.setPassword(null);
        }
        if (uvo.getNickname() == null && uvo.getPassword() == null) {
            throw new IllegalArgumentException("변경하고자 하는 내역이 존재하지 않습니다.");
        }
        return userMapper.updateUser(uvo);
    }

    @Override
    public boolean isLoginIdExist(String loginId) {
        if (loginId == null || loginId.trim().isEmpty()) {
            return false;  // 🔴 NULL이 들어오면 false 반환
        }

        Long count = userMapper.countByLoginId(loginId);  // 🟢 NULL 방지
        return count != null && count > 0; // 🔴 count가 null이면 false 반환
    }

    @Override
    public boolean isEmailExist(String email) {
        if (email == null || email.trim().isEmpty()) {
            return false;
        }

        Long count = userMapper.countByEmail(email);
        return count != null && count > 0;
    }

    @Override
    public boolean isNicknameExist(String nickname) {
        if (nickname == null || nickname.trim().isEmpty()) {
            return false;
        }

        Long count = userMapper.countByNickname(nickname);
        return count != null && count > 0;
    }

    @Override
    @Transactional
    public int registerUser(NlbUserVO uvo) {
        // 비밀번호 해싱
        String hashedPassword = PasswordUtil.hashPassword(uvo.getPassword());
        uvo.setPassword(hashedPassword);

        // 회원가입 진행
        return userMapper.insertUser(uvo);
    }



}
