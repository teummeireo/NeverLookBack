package com.nlb.controller;

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

import java.util.ArrayList;
import java.util.List;

import static org.mockito.Mockito.*;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.put;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@RunWith(SpringRunner.class)
@WebAppConfiguration
@ContextConfiguration(locations = {"file:src/main/webapp/WEB-INF/servlet-context.xml"})
public class ExamRestControllerTest {

    @Autowired
    private WebApplicationContext wac;

    private MockMvc mockMvc;

    @Mock
    private ExamService examService;

    @InjectMocks
    private ExamRestController examRestController;

    @Before
    public void setup() {
        MockitoAnnotations.openMocks(this);
        this.mockMvc = MockMvcBuilders.standaloneSetup(examRestController)
                .build();
    }

    @Test
    public void testExamsOfConstructorEndpoint() throws Exception {
        // Mock 데이터 준비
        int userId = 1;
        String sortBy = "title";
        String order = "asc";
        String category = null;

        // Mock 서비스 동작 정의
        List<ExamVO> examVOList = new ArrayList<>();
        examVOList.add(new ExamVO(1, 1, "exam001", "A Quiz", "history", null, 3,
                5, null, null, null, 30, "closed"));
        examVOList.add(new ExamVO(2, 1, "exam002", "B Quiz", "physics", null, 3,
                5, null, null, null, 30, "closed"));
        when(examService.getExamList(userId, sortBy, order, category)).thenReturn(examVOList);

        // REST API 호출 및 검증
        mockMvc.perform(get("/api/exams/{userId}", userId)
                        .param("sortBy", sortBy)
                        .param("order", order))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.msg").value("성공"))
                .andExpect(jsonPath("$.data.length()").value(2))
                .andExpect(jsonPath("$.data[0].title").value("A Quiz"))
                .andExpect(jsonPath("$.data[1].title").value("B Quiz"));

        // Mock 서비스가 호출되었는지 확인
        verify(examService, times(1)).getExamList(userId, sortBy, order, category);
    }

    @Test
    public void testSetExamStatusEndPoint() throws Exception {

        int examId = 1;
        String status = "on_going";
        when(examService.setExamStatus(examId, status)).thenReturn(1);

        // When & Then: 정상 응답 확인
        mockMvc.perform(put("/api/exams/{examId}/status", examId)
                        .param("status", status))
                .andExpect(status().isOk()) // HTTP 상태 200 확인
                .andExpect(jsonPath("$.msg").value("성공"));

        // 서비스 메서드 호출 여부 확인
        verify(examService, times(1)).setExamStatus(examId, status);
    }



}
