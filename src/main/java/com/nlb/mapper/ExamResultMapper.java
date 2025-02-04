package com.nlb.mapper;


import com.nlb.dto.response.ExamResultCardDTO;
import com.nlb.dto.response.ExamineeInfoResDTO;
import com.nlb.vo.ExamResultVO;
import com.nlb.vo.ResultDetailVO;
import java.util.List;
import java.util.Map;
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

  ExamResultVO selectExamResultByExamIdandUser(@Param("examId") int examId,
      @Param("examineeId") int examineeId);

  List<ResultDetailVO> selectResultDetailByResultId(@Param("resultId") int resultId);

  void insertResultDetail(@Param("details") List<ResultDetailVO> details);

  ExamineeInfoResDTO selectExamineeInfo(@Param("examId") int examId,
      @Param("examineeId") int examineeId);

  ExamResultVO selectExamResultByResultId(@Param("resultId") int resultId);

  void updateScoreByResultId(@Param("resultId") int resultId, @Param("score") int score);

  List<ExamResultVO> selectAllExamResults();

  void updateScoreAndIsCorrect(Map<String, Object> params);

  void updateIsCorrect(Map<String, Object> params);

  void updateExamTotalScore(Map<String, Object> params);

  List<ExamResultVO> selectResultByExamIdAndSubmittedAtIsNull(@Param("examId") int examId);

  void insertExamResultsList(@Param("examResults") List<ExamResultVO> examResults);
}
