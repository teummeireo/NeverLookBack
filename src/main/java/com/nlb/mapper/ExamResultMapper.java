package com.nlb.mapper;


import com.nlb.dto.response.ExamResultCardDTO;
import com.nlb.vo.ExamResultVO;
import com.nlb.vo.ExamVO;
import java.util.List;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

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

  int updateExamResult(ExamResultVO examResultVO);

  void insertExamResult(ExamResultVO examResultVO);

  ExamVO selectExamByCode(String examCode);

}
