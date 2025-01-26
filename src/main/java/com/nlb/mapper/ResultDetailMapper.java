package com.nlb.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

@Mapper
@Repository
public interface ResultDetailMapper {
    int deleteResultDetailByExamId(@Param("examId") int examId);
}
