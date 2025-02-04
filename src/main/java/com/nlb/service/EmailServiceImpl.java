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
        String body = "<div style='width:100%;height:100%;color:#333'>"
                + "<div style='border:1px solid #ccc;width:730px;height:800px;margin:50px auto;border-radius:10px'>"
                + "<div style='color:#000000;margin:0 50px;font-size:20px;text-align:left;margin-top:60px'>"
                + "<h3>안녕하세요, 고객님.</h3>"
                + "</div>"
                + "<div style='color:#000000;margin:0 50px;font-size:19px;text-align:left;margin-top:30px'>NeverLookBack을 찾아주셔서 감사합니다! 인증 코드는</div>"
                + "<div style='color:#0052a9;font-size:30px;margin-top:30px;text-align:center'>"
                + "<h3>" + verificationCode + "</h3>"
                + "</div>"
                + "<div style='color:#000000;margin:0 50px;font-size:19px;text-align:left;margin-top:50px'>이며, 10분 내에 입력해 주시면 감사하겠습니다.</div>"
                + "<div style='margin:0 50px;font-size:20px;text-align:left;margin-top:80px'><img src=\"https://github.com/user-attachments/assets/e603a0e3-3d4f-464b-8f76-286ce6221785\" style=\"height:76px\">"
                + "<div style='border-bottom:2px dashed #000;margin-top:15px'></div>"
                + "</div>"
                + "<div style='color:#808080;margin:0 50px;font-size:19px;text-align:left;margin-top:17px'>타인과 인증 코드를 공유하지 말아 주세요."
                + "<br>시스템 메세지입니다, 해당 메일로 답장을 보내지 말아 주세요."
                + "</div>"
                + "</div>";

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
