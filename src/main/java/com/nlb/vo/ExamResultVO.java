package com.nlb.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Date;
import java.util.List;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class ExamResultVO {
    private int resultId;
    private int examId;
    private int examineeId;
    private int score; // Range: 0-100
    private Date submittedAt; // Default: sysdate
    private boolean isReviewed; // Default: false


    private List<ResultDetailVO> resultDetails;
}