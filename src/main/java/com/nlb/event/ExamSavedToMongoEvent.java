package com.nlb.event;

import lombok.Data;

@Data
public class ExamSavedToMongoEvent {
    private final int examId;

}
