package com.nlb.service;

import com.nlb.mapper.ExamMapper;

import com.nlb.vo.ExamVO;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.MockitoJUnitRunner;

import java.util.ArrayList;
import java.util.List;


import static org.junit.Assert.*;
import static org.junit.Assert.assertEquals;
import static org.mockito.Mockito.*;

@RunWith(MockitoJUnitRunner.class)
public class ExamServiceImplTest {

    @InjectMocks
    private ExamServiceImpl examServiceImpl;

    @Mock
    private ExamMapper examMapper;

    @Test
    public void testGetExamListWithSorting() {
        // 준비: Mock 데이터 설정
        int userId = 1;
        String sortBy = "title";
        String order = "asc";

        List<ExamVO> examVOList = new ArrayList<>();
        examVOList.add(new ExamVO(1, 1, "exam001", "A Quiz", "history", null, 3,
                5, "2024-05-30 13:41:24", "2024-05-31 13:41:24", "2024-05-33 13:41:24", 30, "closed"));
        examVOList.add(new ExamVO(2, 1, "exam002", "B Quiz", "physics", null, 3,
                5, "2024-05-30 13:41:24", "2024-05-31 13:41:24", "2024-05-33 13:41:24", 30, "closed"));
        when(examMapper.selectExamListByCreaterId(userId, sortBy, order, null)).thenReturn(examVOList);

        // 실행
        List<ExamVO> result = examServiceImpl.getExamList(userId, sortBy, order, null);

        // 검증
        assertNotNull(result);
        assertFalse(result.isEmpty());
        assertEquals(2, result.size());
        assertEquals("A Quiz", result.get(0).getTitle());
        assertEquals("B Quiz", result.get(1).getTitle());

        verify(examMapper, times(1)).selectExamListByCreaterId(userId, sortBy, order, null);
    }

    @Test
    public void testSetExamStatus() {
        // 준비: Mock 데이터 설정
        int userId = 1;
        String status = "on_going";


        when(examMapper.updateExamActivationStatus(userId, status)).thenReturn(1);

        // 실행
        int result = examServiceImpl.setExamStatus(userId, status);

        // 검증
        assertNotNull(result);
        assertEquals(1, result);

        verify(examMapper, times(1)).updateExamActivationStatus(userId, status);
    }



}