package com.nlb.service;

import com.nlb.util.EmailSenderUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.Map;
import java.util.Random;

@Service
public class EmailServiceImpl implements EmailService {

    private final Map<String, String> emailCodeStorage = new HashMap<>();

    @Autowired
    private EmailSenderUtil emailSender; // 이메일 발송 유틸리티

    @Override
    public void sendEmailVerificationCode(String email) {
        // 6자리 랜덤 인증 코드 생성
        String verificationCode = String.format("%06d", new Random().nextInt(999999));
        emailCodeStorage.put(email, verificationCode);

        // 이메일 내용 작성
        String subject = "NeverLookBack 회원가입 이메일 인증 확인";
        String body = "<h2>이메일 인증 코드</h2><p>아래의 인증 코드를 입력하세요.</p><h3>" + verificationCode + "</h3>";

        // 실제 이메일 전송
        emailSender.sendEmail(email, subject, body);
    }

    @Override
    public boolean verifyEmailCode(String email, String code) {
        if (emailCodeStorage.containsKey(email) && emailCodeStorage.get(email).equals(code)) {
            emailCodeStorage.remove(email); // 인증 성공 시 코드 제거
            return true;
        }
        return false;
    }
}
