package com.nlb.service;


import com.nlb.vo.ExamVO;

import java.util.List;

public interface ExamService {
    List<ExamVO> getExamList(int userId, String sortBy, String order, String category);
    int setExamStatus(int examId, String status);
    List<Integer> deleteExam(int examId);
}
