package com.nlb.event;

import com.nlb.vo.ExamMongoVO;
import lombok.Data;

@Data
public class ExamCreatedEvent {
    private final int examId;
    private final ExamMongoVO examMongoVO;
}
