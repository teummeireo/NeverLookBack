package com.nlb.service;


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
    public List<ExamResultVO> getExamResultList(int examId, String sortBy, String order, boolean isReviewed) {
        return examResultMapper.selectExamResultList(examId, sortBy, order, isReviewed);
    }

    @Override
    public int setExamResultStatus(int resultId, boolean isReviewed) {
        return examResultMapper.updateExamResultIsReviewed(resultId, isReviewed);
    }


}
