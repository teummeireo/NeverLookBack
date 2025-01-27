package com.nlb.mapper;


import com.nlb.dto.response.ExamResultCardDTO;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringRunner;
import org.springframework.transaction.annotation.Transactional;

import static org.junit.Assert.*;
import static org.junit.Assert.assertEquals;

@RunWith(SpringRunner.class)
@ContextConfiguration(locations = {"file:src/main/webapp/WEB-INF/servlet-context.xml"})
@Transactional
public class ExamResultMapperTest {

    @Autowired
    private ExamMapper examMapper;

    @Autowired
    private ExamResultMapper examResultMapper;

    @Test
    public void testSelectExamResultAndExamByResultId(){
        int resultId = 1;

        ExamResultCardDTO result = examResultMapper.selectExamResultAndExamByResultId(resultId);

        assertNotNull(result);
        assertEquals("EXAM001", result.getExamCode());
        assertEquals(95, result.getScore());
    }

}
