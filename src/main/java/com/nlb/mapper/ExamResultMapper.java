package com.nlb.mapper;


import com.nlb.dto.response.ExamResultCardDTO;
import com.nlb.vo.ExamResultVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Mapper
@Repository
public interface ExamResultMapper {
    int deleteExamResultByExamId(@Param("examId") int examId);
    List<ExamResultVO> selectExamResultList(@Param("examId") int examId,
                                            @Param("sortBy") String sortBy,
                                            @Param("order") String order,
                                            @Param("isReviewed") Boolean isReviewed);

    int updateExamResultIsReviewed(@Param("resultId") int resultId,
                                   @Param("isReviewed") Boolean isReviewed);

    List<ExamResultVO> selectExamResultListByUserId(@Param("userId") int userId,
                                                    @Param("sortBy") String sortBy,
                                                    @Param("order") String order,
                                                    @Param("isReviewed") Boolean isReviewed);

    ExamResultCardDTO selectExamResultAndExamByResultId(@Param("resultId") int resultId);
}
