package com.nlb.exception;

import com.nlb.dto.response.CMResDTO;

import javax.servlet.http.HttpServletRequest;

import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.core.AuthenticationException;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.web.HttpRequestMethodNotSupportedException;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.MissingServletRequestParameterException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;
import org.springframework.web.method.annotation.MethodArgumentTypeMismatchException;
import org.springframework.web.servlet.NoHandlerFoundException;



import java.util.HashMap;
import java.util.Map;

@Slf4j
@RestControllerAdvice
public class GlobalExceptionHandler {

    // validation 체크
    private String bindingResultErrorsCheck(BindingResult bindingResult) {
        Map<String, String> errorMap = new HashMap<>();
        for (FieldError fe : bindingResult.getFieldErrors()) {
            errorMap.put(fe.getField(), fe.getDefaultMessage());
        }
        return errorMap.toString();
    }

    // 토큰이 없는 경우 401
    @ExceptionHandler(AuthenticationException.class)
    public ResponseEntity<CMResDTO<String>> handleAuthenticationException(AuthenticationException e) {
        log.error("[AuthenticationException] message: {}", e.getMessage());
        ErrorCode errorCode = ErrorCode.UNAUTHORIZED;
        return new ResponseEntity<>(CMResDTO.errorRes(errorCode), HttpStatus.UNAUTHORIZED);
    }

    // 권한 없는 경로 접근한 경우 403
    @ExceptionHandler(AccessDeniedException.class)
    public ResponseEntity<CMResDTO<String>> handleAuthorizationServiceException(AccessDeniedException e) {
        log.error("[AccessDeniedException] message: {}", e.getMessage());
        ErrorCode errorCode = ErrorCode.FORBIDDEN;
        return new ResponseEntity<>(CMResDTO.errorRes(errorCode), HttpStatus.FORBIDDEN);
    }

    // 잘못된 경로 에러 404
    @ExceptionHandler(NoHandlerFoundException.class)
    public ResponseEntity<CMResDTO<String>> handleNoHandlerFoundException(NoHandlerFoundException e, HttpServletRequest request) {
        log.error("[NoHandlerFoundException] message: {}", e.getMessage());
        ErrorCode errorCode = ErrorCode.NOT_FOUND;
        return new ResponseEntity<>(CMResDTO.errorRes(errorCode), HttpStatus.NOT_FOUND);
    }

    //Path Value가 없거나 잘못 입력되었을 때 404
    @ExceptionHandler(NoResourceFoundException.class)
    public ResponseEntity<CMResDTO<String>> handleNoHandlerFoundException(NoResourceFoundException e, HttpServletRequest request) {
        log.error("[NoResourceFoundException] message: {}", e.getMessage());
        ErrorCode errorCode = ErrorCode.NOT_VALID_PATH_VALUE;
        return new ResponseEntity<>(CMResDTO.errorRes(errorCode), HttpStatus.NOT_FOUND);
    }

    // Http Method 에러
    @ExceptionHandler(HttpRequestMethodNotSupportedException.class)
    public ResponseEntity<CMResDTO<String>> handleHttpRequestMethodNotSupportedException(HttpRequestMethodNotSupportedException e) {
        log.error("[HttpRequestMethodNotSupportedException] message: {}", e.getMessage());
        ErrorCode errorCode = ErrorCode.METHOD_NOT_ALLOWED;
        return new ResponseEntity<>(CMResDTO.errorRes(errorCode), HttpStatus.METHOD_NOT_ALLOWED);
    }

    // reqeust param 없을 때
    @ExceptionHandler(MissingServletRequestParameterException.class)
    public ResponseEntity<CMResDTO<String>> handleMissingServletRequestParameterException(MissingServletRequestParameterException e) {
        log.error("[MissingServletRequestParameterException] message: {}", e.getMessage());
        ErrorCode errorCode = ErrorCode.MISSING_REQUEST_PARAM;
        return new ResponseEntity<>(CMResDTO.errorWithMsgRes(errorCode, e.getMessage()), HttpStatus.BAD_REQUEST);
    }

    // reqeust param 타입이 안 맞을 때 400
    @ExceptionHandler(MethodArgumentTypeMismatchException.class)
    public ResponseEntity<CMResDTO<String>> handleMethodArgumentTypeMismatchException(MethodArgumentTypeMismatchException e) {
        log.error("[MethodArgumentTypeMismatchException] message: {}", e.getMessage());
        ErrorCode errorCode = ErrorCode.INVALID_TYPE_REQUEST_VALUE;
        return new ResponseEntity<>(CMResDTO.errorRes(errorCode), HttpStatus.BAD_REQUEST);
    }

    // request body의 유효성 에러 400
    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ResponseEntity<CMResDTO<String>> handleMethodArgumentNotValidException(MethodArgumentNotValidException e) {
        log.error("[MethodArgumentNotValidException] message: {}", e.getMessage());
        ErrorCode errorCode = ErrorCode.INVALID_REQUEST_BODY;
        // 유효성 결과 message에 할당
        String message = bindingResultErrorsCheck(e.getBindingResult());
        return new ResponseEntity<>(CMResDTO.errorWithMsgRes(errorCode, message), HttpStatus.BAD_REQUEST);
    }

    // IllegalArgumentException
    @ExceptionHandler(IllegalArgumentException.class)
    public ResponseEntity<CMResDTO<String>> handleIllegalArgumentException(IllegalArgumentException e) {
        log.error("[IllegalArgumentException] message: {}", e.getMessage());
        ErrorCode errorCode = ErrorCode.BAD_REQUEST;
        String message = e.getMessage();
        return new ResponseEntity<>(CMResDTO.errorWithMsgRes(errorCode, message), HttpStatus.BAD_REQUEST);
    }

    // IllegalStateException
    @ExceptionHandler(IllegalStateException.class)
    public ResponseEntity<CMResDTO<String>> handleIllegalStateException(IllegalStateException e) {
        log.error("[IllegalStateException] message: {}", e.getMessage());
        ErrorCode errorCode = ErrorCode.BAD_REQUEST;
        String message = e.getMessage();
        return new ResponseEntity<>(CMResDTO.errorWithMsgRes(errorCode, message), HttpStatus.BAD_REQUEST);
    }

    // 각종 400 에러
    @ExceptionHandler(BadRequestException.class)
    public ResponseEntity<CMResDTO<String>> handleBadRequestException(BadRequestException e) {
        log.error("[BadRequestException] message: {}", e.getMessage());
        ErrorCode errorCode = e.getErrorCode();
        return new ResponseEntity<>(CMResDTO.errorRes(errorCode), HttpStatus.BAD_REQUEST);
    }

    // 각종 404 에러
    @ExceptionHandler(NotFoundException.class)
    public ResponseEntity<CMResDTO<String>> handleNotFoundException(NotFoundException e) {
        log.error("[NotFoundException] message: {}", e.getMessage());
        ErrorCode errorCode = e.getErrorCode();
        return new ResponseEntity<>(CMResDTO.errorRes(errorCode), HttpStatus.NOT_FOUND);
    }

    // 각종 409 에러
    @ExceptionHandler(ConflictException.class)
    public ResponseEntity<CMResDTO<String>> handleConflictException(ConflictException e) {
        log.error("[ConflictException] message: {}", e.getMessage());
        ErrorCode errorCode = e.getErrorCode();
        return new ResponseEntity<>(CMResDTO.errorRes(errorCode), HttpStatus.CONFLICT);
    }

    // 위의 경우를 제외한 모든 에러 500
    @ExceptionHandler(Exception.class)
    public ResponseEntity<CMResDTO<String>> handleException(Exception e) {
        log.error("[Exception] message: {},{}", e.getMessage(), e.getClass(), e.getCause());
        ErrorCode errorCode = ErrorCode.INTERNAL_SERVER_ERROR;
        return new ResponseEntity<>(CMResDTO.errorRes(errorCode), HttpStatus.INTERNAL_SERVER_ERROR);
    }

    // 권한 없음 (403)
    @ExceptionHandler(CustomAccessDeniedException.class)
    public ResponseEntity<CMResDTO<String>> handleAccessDeniedException(CustomAccessDeniedException e) {
        log.error("[CustomAccessDeniedException] message: {}", e.getMessage());
        return new ResponseEntity<>(
            CMResDTO.errorWithMsgRes(ErrorCode.FORBIDDEN, e.getMessage()),
            HttpStatus.FORBIDDEN
        );    }

    @ExceptionHandler(DuplicatedQuestionException.class)
    public ResponseEntity<CMResDTO<String>> handleDuplicatedQuestionException(DuplicatedQuestionException e) {
        log.error("[DuplicatedQuestionException] message: {}", e.getMessage());
        return new ResponseEntity<>(CMResDTO.errorWithMsgRes(e.getErrorCode(), e.getMessage()), HttpStatus.CONFLICT);
    }


}