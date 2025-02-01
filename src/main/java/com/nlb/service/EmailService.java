package com.nlb.service;

public interface EmailService {
    void sendEmailVerificationCode(String email);
    boolean verifyEmailCode(String email, String code);
}

