package com.nlb.service;


import com.nlb.dto.request.ExamResultReqDTO;
import com.nlb.dto.response.ExamDataResDTO;
import com.nlb.dto.response.ExamJoinResDTO;
import com.nlb.dto.response.ExamResultCardDTO;
import com.nlb.dto.response.ExamineeInfoResDTO;
import com.nlb.vo.AnswerVO;
import com.nlb.vo.ExamResultVO;
import java.util.List;
import java.util.Map;

public interface ExamResultService {

  List<ExamResultVO> getExamResultList(int examId, String sortBy, String order, Boolean isReviewed);

  int setExamResultStatus(int resultId, Boolean isReviewed);

  List<ExamResultVO> getExamResultListOfUser(int userId, String sortBy, String order,
      Boolean isReviewed);

  ExamResultCardDTO getExamResultAndExam(int resultId);

  int saveExamAnswers(int resultId, ExamResultReqDTO examResultReqDTO);

  List<AnswerVO> submitExam(int resultId, ExamResultReqDTO examResultReqDTO);

  public ExamJoinResDTO joinExam(int examId, String examCode, int examineeId, String entreeCode);

  Map<String, Object> getExamResultData(int examId, int examineeId);

  public ExamDataResDTO getExamData(int examId, int examineeId);

  public List<AnswerVO> gradingExam(List<AnswerVO> answers, ExamResultVO examResultVO, int resultId,
      int examId);

  public ExamResultVO getResultDetail(int examineeId, int examId, int resultId);

  public ExamineeInfoResDTO getExamineeInfo(int examId, int examineeId);

  public boolean submitObjection(int examId, int examineeId, int questionId, String objectionComments);

  public boolean submitObjectionReply(int examId, int examineeId, int questionId, String objectionReply);


    ExamResultCardDTO getExamResultAndExam(int resultId);

    List<ExamResultVO> getAllExamResults();
}

  public List<Map<String , Object>> getQuestionsState(int examId, int examineeId);
  }