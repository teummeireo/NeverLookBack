package com.nlb.dto.response;


import com.nlb.vo.ExamResultVO;
import com.nlb.vo.ExamVO;
import lombok.*;

@Getter
@Setter
@Data
@AllArgsConstructor
@NoArgsConstructor
public class ExamResultCardDTO {
    private int examId;
    private int creatorId;
    private String examCode;
    private String title;
    private String category;
    private String entreeCode;
    private int questionCount;
    private int examineeCount; // Default: 0
    private String createdAt; // Default: sysdate
    private String startedAt;
    private String finishedAt;
    private int examTime;  //  분단위
    private String activationStatus; // 'not_started', 'on_going', 'closed'
    
    // 내정보
    private int resultId;
    private int examineeId;
    private int score; // Range: 0-100
    private String submittedAt; // Default: sysdate
    private boolean isReviewed; // Default: false

}
