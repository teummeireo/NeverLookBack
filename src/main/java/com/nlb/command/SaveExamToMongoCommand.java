package com.nlb.command;

import com.nlb.vo.ExamMongoVO;
import lombok.Data;

@Data
public class SaveExamToMongoCommand {
    private final ExamMongoVO examMongoVO;
}
