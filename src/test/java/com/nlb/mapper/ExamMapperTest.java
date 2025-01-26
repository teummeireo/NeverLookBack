package com.nlb.mapper;

import com.nlb.vo.ExamVO;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringRunner;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

import static org.junit.Assert.*;

@RunWith(SpringRunner.class)
@ContextConfiguration(locations = {"file:src/main/webapp/WEB-INF/servlet-context.xml"})
@Transactional
public class ExamMapperTest {

    @Autowired
    private ExamMapper examMapper;

    @Autowired
    private ExamResultMapper examResultMapper;

    @Autowired
    private ResultDetailMapper resultDetailMapper;

    @Test
    public void testSelectExamListByCreaterIdWithSorting() {
        // Given: 테스트용 creater_id
        int userId = 1;
        String sortBy = "title";
        String order = "asc";

        // When: 매퍼 호출
        List<ExamVO> result = examMapper.selectExamListByCreaterId(userId, sortBy, order, null);

        // Then: 결과 검증
        assertNotNull(result);
        assertFalse(result.isEmpty());
        assertEquals("Math Exam", result.get(0).getTitle());
        assertEquals("Science Exam", result.get(1).getTitle());
    }

    @Test
    public void testSelectExamListByCreaterIdWithFiltering() {
        // Given: 테스트용 creater_id
        int userId = 1;
        String sortBy = "title";
        String order = "asc";
        String category = "Science";

        // When: 매퍼 호출
        List<ExamVO> result = examMapper.selectExamListByCreaterId(userId, sortBy, order, category);

        // Then: 결과 검증
        assertNotNull(result);
        assertFalse(result.isEmpty());
        assertEquals(1, result.size());
        assertEquals("Science Exam", result.get(0).getTitle());
    }

    @Test
    public void testDeleteExamByExamId() {
        // Given: 테스트용 examId와 status
        int examId = 1;


        // When: 매퍼 호출
        int rows1 = resultDetailMapper.deleteResultDetailByExamId(examId);
        int rows2 = examResultMapper.deleteExamResultByExamId(examId);
        int rows3 = examMapper.deleteExamByExamId(examId);

        // Then: 결과 검증
        assertEquals(15, rows1);
        assertEquals(5, rows2);
        assertEquals(1, rows3);


    }


}