package com.nlb.service;


import com.nlb.dto.response.ExamResultCardDTO;
import com.nlb.mapper.ExamResultMapper;
import com.nlb.vo.ExamResultVO;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ExamResultServiceImpl implements ExamResultService {

    @Autowired
    private ExamResultMapper examResultMapper;

    @Override
    public List<ExamResultVO> getExamResultList(int examId, String sortBy, String order, Boolean isReviewed) {
        return examResultMapper.selectExamResultList(examId, sortBy, order, isReviewed);
    }

    @Override
    public int setExamResultStatus(int resultId, Boolean isReviewed) {
        return examResultMapper.updateExamResultIsReviewed(resultId, isReviewed);
    }

    @Override
    public List<ExamResultVO> getExamResultListOfUser(int userId, String sortBy, String order, Boolean isReviewed) {
        return examResultMapper.selectExamResultListByUserId(userId, sortBy, order, isReviewed);
    }

    @Override
    public ExamResultCardDTO getExamResultAndExam(int resultId) {
        return examResultMapper.selectExamResultAndExamByResultId(resultId);
    }


}
