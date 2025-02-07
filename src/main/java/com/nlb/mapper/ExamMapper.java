package com.nlb.mapper;


import com.nlb.vo.ExamVO;
import com.nlb.vo.ExamWithCreatorVO;
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

  ExamVO selectExamByResultId(@Param("resultId") int resultId);

  List<ExamWithCreatorVO> findExamsByName(@Param("name") String name);

  List<ExamWithCreatorVO> searchExams(@Param("name") String name,
      @Param("category") String category,
      @Param("nickname") String nickname,
      @Param("createdAt") String createdAt,
      @Param("activationStatus") String activationStatus,
      @Param("examTime") Integer examTime,
      @Param("roomType") String roomType,
      @Param("examId") int examId);

  List<ExamVO> searchAllExams();

  List<ExamVO> searchExams(@Param("name") String name);

}