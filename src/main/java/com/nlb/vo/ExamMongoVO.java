package com.nlb.vo;


import lombok.*;

import java.util.List;

@Getter
@Setter
@Data
@AllArgsConstructor
@NoArgsConstructor
public class ExamMongoVO {      // MongoDB 에 시험 디테일 저장하는 VO

    private String examId;
    private String examCode;
    private String title;
    private String category;
    private String entreeCode;
    private int questionCount;

    private List<Question> questions;
}

@Getter
@Setter
@Data
@AllArgsConstructor
@NoArgsConstructor
class Question {
    private int questionId;
    private String content;
    private String type;
    private List<String> options;
    private String correctAnswer;
    private int pointsAllocation;
    private int maxOptionsNum; // 객관식일 경우 최대 보기 개수
    private int maxAnswerLength; // 서술형일 경우 최대 답변 길이


}