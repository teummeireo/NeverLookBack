package com.nlb.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Date;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class NlbUserVO {
    private int userId;
    private String loginId;
    private String password;
    private String nickname;
    private String email;
    private String userRole; // 'user', 'admin'
    private Date regDate; // Default: sysdate
    private boolean isActive; // Default: true
}