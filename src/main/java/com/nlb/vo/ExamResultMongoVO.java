package com.nlb.vo;


import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.util.List;
import java.util.Date;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class ExamResultMongoVO {
    private int resultId;
    private int examId;
    private int examineeId;
    private List<Answer> answers;
    private Date submittedAt;

    // 응시자의 답변 주의 : 답안지가 아님!!!!!!!
    @Data
    @AllArgsConstructor
    @NoArgsConstructor
    public static class Answer {
        private int questionId;
        private String answer;           // 응시자가 선택한 답변
        private boolean isCorrect;       // 정답 여부
        private int pointsEarned;        // 획득 점수
        private boolean isObjection;     // 이의제기 여부
        private String objectionComments; // 이의제기 코멘트 (이의제기 시)
        private String objectionReply;   // 이의제기에 대한 답변
    }
}