package com.nlb.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Date;

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
    private Date createdAt; // Default: sysdate
    private Date startedAt;
    private Date finishedAt;
    private int examTime;
    private String activationStatus; // 'not_started', 'on_going', 'closed'
}