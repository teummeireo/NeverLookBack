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




}