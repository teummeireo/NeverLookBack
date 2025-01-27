package com.nlb.mapper;

import com.nlb.vo.NlbUserVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Mapper
@Repository
public interface NlbUserMapper {
    boolean existsById(String id); // ID가 존재하는지 여부 확인

    List<NlbUserVO> selectUsers();

    int updateUserIsActive(@Param("userId") int userId,
                           @Param("isActive") Boolean isActive);
}
