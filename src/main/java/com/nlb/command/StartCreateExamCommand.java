package com.nlb.command;

import com.nlb.dto.request.ExamReqDTO;
import lombok.Data;

// StartCreateExamCommand.java

@Data
public class StartCreateExamCommand {
    private final ExamReqDTO examReqDTO;

}
