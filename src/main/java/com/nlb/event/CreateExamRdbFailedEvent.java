package com.nlb.event;

import lombok.Data;

@Data
public class CreateExamRdbFailedEvent {
    private final String reason;
}
