package com.nlb.dto.response;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class ExamJoinResDTO {

  private int examId;
  private int resultId;
  private String examCode;
  private int examineeId;
  private String redirectUrl;
}