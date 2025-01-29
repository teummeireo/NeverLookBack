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
public class ExamResultMongoVO {

  private int resultId;
  private List<AnswerVO> answers;
}