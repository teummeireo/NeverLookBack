package com.nlb.service;


import com.nlb.vo.ExamResultVO;

import java.util.List;

public interface ExamResultService {
    List<ExamResultVO> getExamResultList(int examId, String sortBy, String order, boolean isReviewed);
    int setExamResultStatus(int resultId, boolean isReviewed);
}
