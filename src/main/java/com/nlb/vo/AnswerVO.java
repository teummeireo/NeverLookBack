package com.nlb.vo;


import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

// 응시자의 답변 주의 : 답안지가 아님!!!!!!!
@Getter
@Setter
@Data
@AllArgsConstructor
@NoArgsConstructor
public class AnswerVO {

  private int questionId;
  private String answer;           // 응시자가 선택한 답변
  private boolean isCorrect;       // 정답 여부
  private int pointsEarned;        // 획득 점수
  private boolean isObjection;     // 이의제기 여부
  private String objectionComments; // 이의제기 코멘트 (이의제기 시)
  private String objectionReply;   // 이의제기에 대한 답변
}