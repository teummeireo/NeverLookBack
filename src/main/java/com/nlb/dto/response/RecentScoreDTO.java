package com.nlb.dto.response;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class RecentScoreDTO {
    private String examTitle;
    private int score;
    private String submittedDate;
}
