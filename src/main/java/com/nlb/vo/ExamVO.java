package com.nlb.vo;

import lombok.*;

import java.util.Date;

@Getter
@Setter
@Data
@AllArgsConstructor
@NoArgsConstructor
public class ExamVO {
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
}