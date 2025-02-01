package com.nlb.vo;

import com.fasterxml.jackson.annotation.JsonFormat;
import java.time.LocalDateTime;
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
public class ExamResultVO {

  private int resultId;
  private int examId;
  private int examineeId;
  private int score; // Range: 0-100
  @JsonFormat(pattern = "yyyy-MM-dd'T'HH:mm:ss")
  private LocalDateTime submittedAt; // Default: sysdate
  private boolean isReviewed; // Default: false


  private List<ResultDetailVO> resultDetails;
}