//package com.nlb.service;
//
//import com.nlb.dto.response.ExamResultCardDTO;
//import com.nlb.mapper.ExamResultMapper;
//import com.nlb.vo.ExamVO;
//import org.junit.Test;
//import org.junit.runner.RunWith;
//import org.mockito.InjectMocks;
//import org.mockito.Mock;
//import org.mockito.junit.MockitoJUnitRunner;
//
//import static org.junit.Assert.*;
//import static org.junit.Assert.assertEquals;
//import static org.mockito.Mockito.*;
//import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
//import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
//import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;
//
//@RunWith(MockitoJUnitRunner.class)
//public class ExamResultServiceImplTest {
//
//    @InjectMocks
//    private ExamResultServiceImpl examResultServiceImpl;
//
//    @Mock
//    private ExamResultMapper examResultMapper;
//
//
//    @Test
//    public void testGetExamResultAndExam() {
//        int resultId = 1;
//        ExamResultCardDTO examResultCardDTO = new ExamResultCardDTO();
//        examResultCardDTO.setExamCode("exam001");
//        when(examResultMapper.selectExamResultAndExamByResultId(resultId)).thenReturn(examResultCardDTO);
//
//        ExamResultCardDTO result = examResultServiceImpl.getExamResultAndExam(resultId);
//
//        // 검증
//        assertNotNull(result);
//        assertEquals("exam001", result.getExamCode());
//
//        // Mock 서비스가 호출되었는지 확인
//        verify(examResultMapper, times(1)).selectExamResultAndExamByResultId(resultId);
//    }
//}
