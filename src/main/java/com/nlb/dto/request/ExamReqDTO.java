package com.nlb.dto.request;


import com.nlb.vo.ExamMongoVO;
import com.nlb.vo.ExamVO;
import lombok.*;

@Getter
@Setter
@Data
@AllArgsConstructor
@NoArgsConstructor
public class ExamReqDTO {

    private ExamVO examVO;
    private ExamMongoVO examMongoVO;
}
