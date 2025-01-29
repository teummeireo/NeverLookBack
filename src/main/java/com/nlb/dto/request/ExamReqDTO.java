package com.nlb.dto.request;

import com.nlb.vo.ExamMongoVO;
import com.nlb.vo.ExamVO;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class ExamReqDTO {

  private ExamVO examVO;
  private ExamMongoVO examMongoVO;
}
