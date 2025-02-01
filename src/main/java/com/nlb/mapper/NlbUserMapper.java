package com.nlb.mapper;

import com.nlb.vo.NlbUserVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Mapper
@Repository
public interface NlbUserMapper {

    List<NlbUserVO> selectUsers();

    int updateUserIsActive(@Param("userId") int userId,
                           @Param("isActive") Boolean isActive);

    NlbUserVO selectUserByUserId(@Param("userId") int userId);

    int updateUserDeactivate(@Param("userId") int userId);

    String selectNicknameByUserId(@Param("userId") int userId);

    String selectPasswordByUserId(@Param("userId") int userId);

    int updateUser(@Param("uvo") NlbUserVO uvo);

    int insertUser(NlbUserVO uvo);

    long countByLoginId(@Param("loginId") String loginId);
    long countByNickname(@Param("nickname") String nickname);
    long countByEmail(@Param("email") String email);

    // 로그인
    NlbUserVO selectUserByLoginId(@Param("loginId") String loginId);
}
