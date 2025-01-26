package com.nlb.service;

import com.nlb.mapper.NlbUserMapper;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.MockitoJUnitRunner;

import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertTrue;
import static org.mockito.Mockito.*;

@RunWith(MockitoJUnitRunner.class)
public class NlbUserServiceImplTest {
    @InjectMocks
    private NlbUserServiceImpl nlbUserService; // 테스트할 구현체

    @Mock
    private NlbUserMapper nlbUserMapper; // 의존성을 Mock으로 설정

    @Test
    public void testIsUniqueIdWithUniqueId() {
        // 준비: Mock 데이터 설정
        String id = "uniqueId";
        when(nlbUserMapper.existsById(id)).thenReturn(false); // ID가 없다고 가정

        // 실행
        boolean result = nlbUserService.isUniqueId(id);

        // 검증
        assertTrue(result); // ID가 고유해야 함
        verify(nlbUserMapper, times(1)).existsById(id); // Repository 호출 확인
    }

    @Test
    public void testIsUniqueIdWithDuplicateId() {
        // 준비: Mock 데이터 설정
        String id = "duplicateId";
        when(nlbUserMapper.existsById(id)).thenReturn(true); // ID가 이미 존재한다고 가정

        // 실행
        boolean result = nlbUserService.isUniqueId(id);

        // 검증
        assertFalse(result); // ID가 고유하지 않아야 함
        verify(nlbUserMapper, times(1)).existsById(id); // Repository 호출 확인
    }


}