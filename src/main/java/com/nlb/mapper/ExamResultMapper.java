package com.nlb.mapper;


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
                                            @Param("isReviewed") boolean isReviewed);

    int updateExamResultIsReviewed(@Param("resultId") int resultId,
                                   @Param("isReviewed") boolean isReviewed);
}
