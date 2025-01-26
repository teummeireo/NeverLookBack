package com.nlb.vo;

import lombok.*;

import java.util.Date;
import java.util.List;

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
    private String submittedAt; // Default: sysdate
    private boolean isReviewed; // Default: false


    private List<ResultDetailVO> resultDetails;
}