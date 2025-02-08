package com.nlb.service;


import com.nlb.dto.request.ExamReqDTO;
import com.nlb.dto.response.CategoryCountResponseDTO;
import com.nlb.vo.ExamVO;
import com.nlb.vo.ExamWithCreatorVO;
import com.nlb.vo.QuestionVO;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;
import javax.persistence.criteria.CriteriaBuilder.In;

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

  Map<String, Object> getExamDataCreated(int examId, int creatorId);

  List<ExamWithCreatorVO> searchExamsByName(String name);

  List<ExamWithCreatorVO> filterExam(String name, String category, String nickname, String createdAt, String activationStatus, Integer examTime, String entreeCode, int examId);

  boolean isTimeOver(int examId, LocalDateTime finishTime);

  List<ExamVO> getAllExams();

  List<String> searchCategories();

  List<CategoryCountResponseDTO> getExamCategoryCount();

}
