package com.nlb.dto.response;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class ExamResultDTO {

    private int resultId;
    private String nickname;
    private int examId;
    private int examineeId;
    private int score; // Range: 0-100
    @JsonFormat(pattern = "yyyy-MM-dd'T'HH:mm:ss")
    private LocalDateTime submittedAt; // Default: sysdate
    private boolean isReviewed; // Default: false
}
