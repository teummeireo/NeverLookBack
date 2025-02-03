package com.nlb.dto.response;

import com.nlb.vo.AnswerVO;
import com.nlb.vo.QuestionVO;
import java.time.LocalDateTime;
import java.util.Date;
import java.util.List;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class FullExamDataResDTO {

  private int examId;
  private String title;
  private String category;
  private int createrId;
  private String entreeCode;
  private int examTime;
  private LocalDateTime startedAt;
  private LocalDateTime finishedAt;
  private int questionCount;
  private int resultId;
  private int examineeId;
  private List<QuestionVO> questions;
  private List<AnswerVO> submittedAnswers;

}
