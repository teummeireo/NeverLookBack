package com.nlb.controller;

import com.nlb.dto.response.ExamResultCardDTO;
import com.nlb.service.ExamResultService;
import com.nlb.service.ExamService;
import com.nlb.vo.ExamVO;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringRunner;
import org.springframework.test.context.web.WebAppConfiguration;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.web.context.WebApplicationContext;

import static org.mockito.Mockito.*;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;


@RunWith(SpringRunner.class)
@WebAppConfiguration
@ContextConfiguration(locations = {"file:src/main/webapp/WEB-INF/servlet-context.xml"})
public class ExamResultRestControllerTest {

    @Autowired
    private WebApplicationContext wac;

    private MockMvc mockMvc;

    @Mock
    private ExamResultService examResultService;

    @InjectMocks
    private ExamResultRestController examResultRestController;

    @Before
    public void setup() {
        MockitoAnnotations.openMocks(this);
        this.mockMvc = MockMvcBuilders.standaloneSetup(examResultRestController)
                .build();
    }

    @Test
    public void testexamResultCardEndPoint() throws Exception {

        int resultId = 1;
        ExamResultCardDTO examResultCardDTO = new ExamResultCardDTO();
        examResultCardDTO.setExamCode("exam001");
        when(examResultService.getExamResultAndExam(resultId)).thenReturn(examResultCardDTO);


        // REST API 호출 및 검증
        mockMvc.perform(get("/api/exams/results/{resultId}/card", resultId))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.msg").value("성공"))
                .andExpect(jsonPath("$.data.examCode").value("exam001"));

        // Mock 서비스가 호출되었는지 확인
        verify(examResultService, times(1)).getExamResultAndExam(resultId);
    }
}
