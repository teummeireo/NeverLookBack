package com.nlb.dto.request;

import com.nlb.vo.AnswerVO;
import java.util.List;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class ScoreUpdateReqDTO {

  private int examId;
  private int examineeId;
  private int resultId;
  private List<AnswerVO> answers;
  private int questionId;
}
