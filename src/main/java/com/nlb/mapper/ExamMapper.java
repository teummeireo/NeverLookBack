package com.nlb.mapper;


import com.nlb.vo.ExamVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Mapper
@Repository
public interface ExamMapper {
    List<ExamVO> selectExamListByCreaterId(@Param("userId") int userId,
                                           @Param("sortBy") String sortBy,
                                           @Param("order") String order,
                                           @Param("category") String category);

    int updateExamActivationStatus(@Param("examId") int examId,
                                   @Param("status") String status);

    int deleteExamByExamId(@Param("examId") int examId);
}
