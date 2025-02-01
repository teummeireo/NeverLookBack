package com.nlb.exception;

import lombok.Getter;
import lombok.RequiredArgsConstructor;

@Getter
@RequiredArgsConstructor
public class CustomAccessDeniedException extends RuntimeException {

  private final ErrorCode errorCode;

  public CustomAccessDeniedException(String message) {
    super(message);
    this.errorCode = ErrorCode.FORBIDDEN;
  }
}
