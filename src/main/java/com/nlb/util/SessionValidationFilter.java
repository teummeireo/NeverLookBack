package com.nlb.util;


import org.springframework.stereotype.Component;

import javax.servlet.*;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@Component
public class SessionValidationFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // 필터 초기화 작업
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        // 캐시 제어 헤더 추가
        httpResponse.setHeader("Cache-Control", "private, no-cache, no-store, must-revalidate");
        httpResponse.setHeader("Expires", "0");
        httpResponse.setHeader("Pragma", "no-cache");

        // 다음 필터 또는 서블릿으로 요청 전달
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
        // 필터 파괴 작업
    }
}