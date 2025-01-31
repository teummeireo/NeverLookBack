package com.nlb.mapper;


import com.nlb.vo.ExamVO;
import java.util.List;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

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

  int insertExam(ExamVO examVO);

  int updateExam(ExamVO examVO);

  int updateQuestionCount(@Param("examId") int examId, @Param("questionCount") int questionCount);

  List<ExamVO> selectExamList(@Param("sortBy") String sortBy,
                              @Param("order") String order,
                              @Param("category") String category);

  ExamVO selectExamById(@Param("examId") int examId);

  ExamVO selectExamByCodeAndUser(@Param("examCode") String examCode,
                                 @Param("examineeId") int examineeId);

  ExamVO selectExamByResultId(@Param("resultId") int resultId);

  ExamVO selectExamByResultId(int resultId);
}

