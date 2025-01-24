package com.nlb.controller;

import com.nlb.service.NlbUserService;

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
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@RunWith(SpringRunner.class)
@WebAppConfiguration
@ContextConfiguration(locations = {"file:src/main/webapp/WEB-INF/servlet-context.xml"})
public class NlbUserRestControllerTest {

    @Autowired
    private WebApplicationContext wac;

    private MockMvc mockMvc;

    @Mock
    private NlbUserService nlbUserService;

    @InjectMocks
    private NlbUserRestController nlbUserRestController;

    @Before
    public void setup() {
        // 초기화 및 MockMvc 설정
        MockitoAnnotations.openMocks(this);
        this.mockMvc = MockMvcBuilders.standaloneSetup(nlbUserRestController).build();
    }

    @Test
    public void testCheckIdUniqueEndpoint() throws Exception {
        // Mock 데이터 준비
        String id = "testUserId";

        // Mock 서비스 동작 정의
        when(nlbUserService.isUniqueId(id)).thenReturn(true); // "testUserId"가 고유하다고 가정

        // REST API 호출 및 검증
        mockMvc.perform(post("/users/check-id/{id}", id))
                .andExpect(status().isOk()) // 상태 코드 200 확인
                .andExpect(jsonPath("$.isUnique").value(true)); // JSON 응답의 message 확인

        // Mock 서비스가 호출되었는지 확인
        verify(nlbUserService, times(1)).isUniqueId(id);
    }

    @Test
    public void testCheckIdUniqueEndpointWithDuplicateId() throws Exception {
        // Mock 데이터 준비
        String id = "duplicateUserId";

        // Mock 서비스 동작 정의
        when(nlbUserService.isUniqueId(id)).thenReturn(false); // "duplicateUserId"는 고유하지 않다고 가정

        // REST API 호출 및 검증
        mockMvc.perform(post("/users/check-id/{id}", id))
                .andExpect(status().isOk()) // 상태 코드 200 확인
                .andExpect(jsonPath("$.isUnique").value(false)); // JSON 응답의 isUnique 확인

        // Mock 서비스가 호출되었는지 확인
        verify(nlbUserService, times(1)).isUniqueId(id);
    }

    @Test
    public void testCheckIdUniqueEndpointWithException() throws Exception {
        // Mock 데이터 준비
        String id = "errorUserId";

        // Mock 서비스 동작 정의
        when(nlbUserService.isUniqueId(id)).thenThrow(new RuntimeException("Test Exception"));

        // REST API 호출 및 검증
        mockMvc.perform(post("/users/check-id/{id}", id))
                .andExpect(status().isInternalServerError()); // 상태 코드 500 확인
    }
}
