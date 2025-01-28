package com.nlb.event;

import lombok.Data;

@Data
public class CreateExamMongoFailedEvent {
    private final int examId;
    private final String reason;
}
