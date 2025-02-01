package com.nlb.util;

import javax.mail.MessagingException;
import javax.mail.internet.MimeMessage;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Component;

@Component
public class EmailSenderUtil {

  @Autowired
  private JavaMailSender mailSender; // JavaMailSender 자동 주입

  public void sendEmail(String to, String subject, String body) {
    try {
      MimeMessage message = mailSender.createMimeMessage();
      MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");

      helper.setTo(to); // 수신자 이메일
      helper.setSubject(subject); // 이메일 제목
      helper.setText(body, true); // HTML 지원

      mailSender.send(message);
      System.out.println("이메일 전송 성공");

    } catch (MessagingException e) {
      e.printStackTrace();
      System.err.println("이메일 전송 실패 : " + e.getMessage());
    }
  }
}
