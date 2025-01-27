package com.nlb.vo;


import com.fasterxml.jackson.annotation.JsonFormat;
import java.time.LocalDateTime;
import lombok.*;

import java.util.List;

@Getter
@Setter
@Data
@AllArgsConstructor
@NoArgsConstructor
public class ExamMongoVO {      // MongoDB 에 시험 디테일 저장하는 VO

    private int examId;  //todo 유니크ID 관련, examVO랑 매칭 컨벤션 정리 필요
    private String examCode;
    private String title;
    private String category;
    private String entreeCode;
    private int questionCount;
    private int examTime;
    @JsonFormat(pattern = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS")
    private LocalDateTime startedAt;
    @JsonFormat(pattern = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS")
    private LocalDateTime finishedAt;


    private List<QuestionVO> questions;
}

