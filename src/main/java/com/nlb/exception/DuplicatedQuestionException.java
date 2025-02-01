package com.nlb.exception;

import lombok.Data;

@Data
public class DuplicatedQuestionException extends RuntimeException {

  private final ErrorCode errorCode;
  private final String message;

  public DuplicatedQuestionException(ErrorCode errorCode, String message) {
    super(message); // 부모 클래스에도 메시지 저장
    this.errorCode = errorCode;
    this.message = message;
  }
}
