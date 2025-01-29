package com.nlb.exception;

import lombok.Getter;

@Getter
public enum ErrorCode {
  BAD_REQUEST(400, "유효하지 않은 요청"),
  INVALID_REQUEST_BODY(400, "올바르지 않는 Request Body"),
  INVALID_TYPE_REQUEST_VALUE(400, "올바르지 않은 타입의 Request Value"),
  MISSING_REQUEST_PARAM(400, "필수 파라미터 존재하지 않음"),
  INVALID_USER_PASSWORD(400, "현재 비밀번호가 올바르지 않습니다. 다시 확인해주세요."),
  USER_MODIFY_PASSWORD_FAILURE(400, "현재 비밀번호와 새 비밀번호는 동일할 수 없습니다. 다른 비밀번호를 입력해주세요."),
  INVALID_STATE_PARAM(400, "잘못된 상태 값"),
  INVALID_SEARCH_VALUE(400, "검색 값이 비어있음"),
  INVALID_EMAIL_CODE(400, "인증 코드가 일치하지 않음"),

  UNAUTHORIZED(401, "로그인이 필요한 서비스"),
  FAIL_LOGIN(401, "아이디, 비밀번호 오류"),
  INVALID_TOKEN(401, "잘못된 토큰입니다."),
  EXPIRED_TOKEN(401, "만료된 토큰입니다."),

  FORBIDDEN(403, "접근 권한 없음"),

  NOT_FOUND(404, "잘못된 경로"),
  NOT_VALID_PATH_VALUE(404, "잘못된 Path Variable"),

  METHOD_NOT_ALLOWED(405, "잘못된 Http Method"),


  INTERNAL_SERVER_ERROR(500, "서버 내부 오류"),

  //Exam 관련
  DUPLICATED_QUESTIONID_EXIST(500, "중복 문제ID 존재"),
  EXAM_NOT_FOUND(400, "시험이 존재하지 않습니다"),
  EXAM_NOT_STARTED(400, "시험이 아직 시작되지 않았습니다");

  private final int code;
  private final String msg;

  private ErrorCode(int code, String msg) {
    this.code = code;
    this.msg = msg;
  }
}