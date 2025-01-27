package com.nlb.service;


import com.nlb.mapper.ExamMapper;
import com.nlb.mapper.ExamResultMapper;
import com.nlb.mapper.ResultDetailMapper;
import com.nlb.vo.ExamVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

@Service
public class ExamServiceImpl implements ExamService {

    @Autowired
    private ExamMapper examMapper;

    @Autowired
    private ExamResultMapper examResultMapper;

    @Autowired
    private ResultDetailMapper resultDetailMapper;

    @Override
    public List<ExamVO> getExamList(int userId, String sortBy, String order, String category) {
        return examMapper.selectExamListByCreaterId(userId, sortBy, order, category);
    }

    @Override
    public int setExamStatus(int examId, String status) {
        return examMapper.updateExamActivationStatus(examId,status);
    }

    @Override
    public List<Integer> deleteExam(int examId) {
        List<Integer> rows = new ArrayList<>();
        rows.add(resultDetailMapper.deleteResultDetailByExamId(examId));
        rows.add(examResultMapper.deleteExamResultByExamId(examId));
        rows.add(examMapper.deleteExamByExamId(examId));
        return rows;
    }

    @Override
    public List<ExamVO> getAllExams(String sortBy, String order, String category) {
        return examMapper.selectExamList(sortBy, order, category);
    }
}
