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
public class ExamMongoVO {      // MongoDB 에 시험 디테일 저장하는 VO

  private int examId;
  private List<QuestionVO> questions;
}

