<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="../css/my_page.css">
    <title>My Page</title>
</head>
<body>
<div class="sidebar">
    <ul>
        <li><a href="/jsp/main.jsp">메인페이지</a></li>
        <li><a href="/jsp/make_exam.jsp">시험생성</a></li>
        <li><a href="/jsp/exam_apply.jsp">시험응시</a></li>
        <li><a href="/jsp/manageExam.jsp">시험관리</a></li>
        <li><a href="/jsp/.jsp">응시한 시험</a></li>
        <li><a href="/jsp/my_exam.jsp">마이페이지</a></li>
        <li><a href="/jsp/logout.jsp">로그아웃</a></li>
    </ul>
</div>
<div class="main-container">
    <div class="profile-section">
        <div class="profile-icon">
            <i class="fas fa-user-circle"></i>
        </div>
        <h1>${userId} 님, 안녕하세요!</h1>
    </div>
    <hr class="divider">
    <div class="card-container">
        <div class="card">
            <br>
            <i class="fas fa-user-edit"></i>
            <p class="card-title">
            <a href="page_edit.jsp" style="text-decoration: none; color: inherit;">회원정보 수정</a>
            </p>
            <p class="card-description">회원 정보, 비밀번호 및 닉네임 변경 등 <br> 내 정보를 수정하세요.</p>
        </div>
        <div class="card">
            <i class="fas fa-user-times"></i>
            <p class="card-title">
                <a href="unregister_user.jsp" style="text-decoration: none; color: inherit;">회원 탈퇴</a>
            </p>
            <p class="card-description">회원 탈퇴를 진행합니다.</p>
        </div>
    </div>
</div>
</body>
</html>