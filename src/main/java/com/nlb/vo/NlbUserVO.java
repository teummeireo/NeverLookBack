package com.nlb.vo;

import lombok.*;

import java.util.Date;

@Getter
@Setter
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
    private String regDate; // Default: sysdate
    private boolean isActive; // Default: true
}