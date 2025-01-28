package com.nlb.vo;

import java.util.List;
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
public class QuestionVO {

  private int questionId;
  private String content;
  private String type;
  private List<String> options;
  private String correctAnswer;
  private int pointsAllocation;
  private int maxOptionsNum; // 객관식일 경우 최대 보기 개수
  private int maxAnswerLength; // 서술형일 경우 최대 답변 길이


}
