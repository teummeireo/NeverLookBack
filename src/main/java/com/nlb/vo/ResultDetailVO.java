package com.nlb.vo;

import lombok.*;

@Getter
@Setter
@Data
@AllArgsConstructor
@NoArgsConstructor
public class ResultDetailVO {
    private int detailId;
    private int resultId;
    private int examId;
    private int questionId;
    private boolean isCorrect; // True if correct, false otherwise
}