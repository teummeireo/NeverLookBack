package com.nlb.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

@Mapper
@Repository
public interface NlbUserMapper {
    boolean existsById(String id); // ID가 존재하는지 여부 확인
}
