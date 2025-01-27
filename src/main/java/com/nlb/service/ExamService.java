package com.nlb.service;


import com.nlb.vo.ExamMongoVO;
import com.nlb.vo.ExamVO;

import com.nlb.vo.QuestionVO;
import java.util.List;

public interface ExamService {
    List<ExamVO> getExamList(int userId, String sortBy, String order, String category);
    int setExamStatus(int examId, String status);
    List<Integer> deleteExam(int examId);

    int createExam(ExamMongoVO examMongoVO);

    boolean updateExam(int examId, ExamMongoVO examMongoVO);

    boolean updateQuestions(int examId, List<QuestionVO> questions);

}
