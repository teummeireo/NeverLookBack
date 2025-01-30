package com.nlb.dto.response;

import com.nlb.vo.AnswerVO;
import com.nlb.vo.QuestionVO;
import java.util.List;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class ExamDataResDTO {


  private int examId;
  private int resultId;
  private int examineeId;
  private List<QuestionVO> questions;
  private List<AnswerVO> submittedAnswers;

}
