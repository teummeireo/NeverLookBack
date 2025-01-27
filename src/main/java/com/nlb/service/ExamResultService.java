package com.nlb.service;


import com.nlb.dto.response.ExamResultCardDTO;
import com.nlb.vo.ExamResultVO;

import java.util.List;

public interface ExamResultService {
    List<ExamResultVO> getExamResultList(int examId, String sortBy, String order, Boolean isReviewed);
    int setExamResultStatus(int resultId, Boolean isReviewed);

    List<ExamResultVO> getExamResultListOfUser(int userId, String sortBy, String order, Boolean isReviewed);

    ExamResultCardDTO getExamResultAndExam(int resultId);
}
