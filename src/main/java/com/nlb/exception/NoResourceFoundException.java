package com.nlb.exception;

import lombok.Getter;
import lombok.RequiredArgsConstructor;

@Getter
@RequiredArgsConstructor
public class NoResourceFoundException extends RuntimeException {
    private final ErrorCode errorCode;
}
