package com.nlb.mapper;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringRunner;

import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertTrue;

@RunWith(SpringRunner.class)
@ContextConfiguration(locations = {"file:src/main/webapp/WEB-INF/servlet-context.xml"})
public class NlbUserMapperTest {

    @Autowired
    private NlbUserMapper nlbUserMapper;

    @Test
    public void testExistsByIdWithExistingId() {
        // 준비: 테스트 데이터 삽입
        String id = "existingId";
        insertTestData(id); // 테스트 데이터를 삽입하는 메서드

        // 실행
        boolean exists = nlbUserMapper.existsById(id);

        // 검증
        assertTrue(exists); // ID가 존재해야 함
    }

    @Test
    public void testExistsByIdWithNonExistingId() {
        // 준비
        String id = "nonExistingId";

        // 실행
        boolean exists = nlbUserMapper.existsById(id);

        // 검증
        assertFalse(exists); // ID가 존재하지 않아야 함
    }

    private void insertTestData(String id) {
        // 테스트 데이터 삽입 로직 (예: SQL 실행)
        // DataSource 또는 JdbcTemplate을 사용할 수 있음
    }
}