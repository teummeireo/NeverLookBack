package com.nlb.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

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