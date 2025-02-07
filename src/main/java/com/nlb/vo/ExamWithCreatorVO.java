package com.nlb.vo;

import com.fasterxml.jackson.annotation.JsonFormat;
import java.time.LocalDateTime;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class ExamWithCreatorVO {
  private int examId;
  private String examCode;
  private String title;
  private String category;
  private String activationStatus;
  private int examTime;
  private String nickname; // Creator's nickname
  @JsonFormat(pattern = "yyyy-MM-dd'T'HH:mm:ss")
  private LocalDateTime createdAt;
  private String entreeCode;
}
