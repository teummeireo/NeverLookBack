package com.nlb.vo;


import lombok.*;

import java.util.List;

@Getter
@Setter
@Data
@AllArgsConstructor
@NoArgsConstructor
public class ExamMongoVO {      // MongoDB 에 시험 디테일 저장하는 VO

    private int examId;  //todo 유니크ID 관련, examVO랑 매칭 컨벤션 정리 필요
    private List<QuestionVO> questions;
}

