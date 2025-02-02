<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" 	uri="http://java.sun.com/jsp/jstl/core" %>
<!-- Font Awesome CDN 추가 -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">

<aside class="sidebar">
  <h2>NeverLookBack</h2>
  <ul>
    <li><a href="/jsp/main.jsp"><i class="fas fa-home"></i><span>메인페이지</span></a></li>
    <li><a href="/jsp/make_exam.jsp"><i class="fas fa-edit"></i><span>시험생성</span></a></li>
    <li><a href="/jsp/exam_apply.jsp"><i class="fas fa-pen"></i><span>시험응시</span></a></li>
    <li><a href="/jsp/manageExam.jsp"><i class="fas fa-cogs"></i><span>시험관리</span></a></li>
    <li><a href="/jsp/exam.jsp"><i class="fas fa-file-alt"></i><span>응시한 시험</span></a></li>
    <li><a href="/mypage"><i class="fas fa-user"></i><span>마이페이지</span></a></li>
    <li><a href="/admin/main"><i class="fas fa-user"></i><span>운영자페이지</span></a></li>
    <c:choose>
    <c:when test="${not empty sessionScope.userId}">
      <li><a href="/jsp/logout.jsp"><i class="fas fa-sign-out-alt"></i><span>로그아웃</span></a></li>
    </c:when>
    <c:otherwise>
      <li><a href="/login"><i class="fas fa-sign-out-alt"></i><span>로그인</span></a></li>
    </c:otherwise>
  </c:choose>

  </ul>
</aside>