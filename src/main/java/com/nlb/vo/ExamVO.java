package com.nlb.vo;

import com.fasterxml.jackson.annotation.JsonFormat;
import java.time.LocalDateTime;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;


@Data
@NoArgsConstructor
@AllArgsConstructor
public class ExamVO {

  private int examId;
  private int createrId;
  private String examCode;
  private String title;
  private String category;
  private String entreeCode;
  private int questionCount;
  private int examineeCount; // Default: 0
  @JsonFormat(pattern = "yyyy-MM-dd'T'HH:mm:ss")
  private LocalDateTime createdAt; // Default: sysdate
  @JsonFormat(pattern = "yyyy-MM-dd'T'HH:mm:ss")
  private LocalDateTime startedAt;
  @JsonFormat(pattern = "yyyy-MM-dd'T'HH:mm:ss")
  private LocalDateTime finishedAt;
  private int examTime;  //  분단위
  private String activationStatus; // 'not_started', 'on_going', 'closed'
}