package com.nlb.service;


import com.nlb.dto.request.ExamReqDTO;
import com.nlb.vo.ExamVO;
import com.nlb.vo.QuestionVO;
import java.util.List;
import java.util.Map;

public interface ExamService {

  List<ExamVO> getExamList(int userId, String sortBy, String order, String category);

  int setExamStatus(int examId, String status);

  List<Integer> deleteExam(int examId);

  public int createExam(ExamReqDTO examReqDTO, int createrId);

  boolean updateExam(int examId, ExamVO examVO);

  int updateQuestions(int examId, List<QuestionVO> questions);

  List<ExamVO> getAllExams(String sortBy, String order, String category);

  String getExamStatus(int examId);

  List<QuestionVO> getExamQuestions(int examId);

  public Map<String, Object> getExamDataCreated(int examId, int creatorId);

}
