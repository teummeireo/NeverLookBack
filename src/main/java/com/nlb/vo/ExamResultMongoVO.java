package com.nlb.vo;


import lombok.*;

import java.util.List;

@Getter
@Setter
@Data
@AllArgsConstructor
@NoArgsConstructor
public class ExamResultMongoVO {


  private int resultId;
  private List<AnswerVO> answers;

}