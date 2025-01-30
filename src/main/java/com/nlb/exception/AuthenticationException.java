package com.nlb.exception;

import lombok.Getter;
import lombok.RequiredArgsConstructor;

@Getter
@RequiredArgsConstructor
public class AuthenticationException extends RuntimeException {

  private final ErrorCode errorCode;
}
