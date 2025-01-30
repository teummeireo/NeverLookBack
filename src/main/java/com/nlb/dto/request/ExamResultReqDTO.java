package com.nlb.dto.request;

import com.nlb.vo.ExamResultMongoVO;
import com.nlb.vo.ExamResultVO;
import lombok.*;

@Data
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class ExamResultReqDTO {

    private ExamResultVO examResultVO;
    private ExamResultMongoVO examResultMongoVO;
}
