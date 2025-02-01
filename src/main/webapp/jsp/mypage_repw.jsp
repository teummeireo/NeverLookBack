<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>비밀번호 변경</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/mypage.css">
</head>
<body>
<div class="container">
    <header>
        <div class="header-left">
            <span class="logo-text">NLB</span>
        </div>
        <div class="header-right">
            <a href="/jsp/main.jsp" class="logout">로그아웃</a>
        </div>
    </header>

    <!-- 새 Sidebar -->
    <div class="sidebar extra">
        <img src="${pageContext.request.contextPath}/images/nlblogo.jpg" alt="Logo"> <!-- 로고 이미지 -->
        <ul>
            <li>추가 메뉴 1</li>
            <li>추가 메뉴 2</li>
            <li>추가 메뉴 3</li>
        </ul>
    </div>

    <div class="content">
        <div class="sidebar-wrapper">
            <!-- 기존 Sidebar -->
            <div class="sidebar">
                <ul>
                    <li class="active">회원정보 수정</li>
                    <li>닉네임 변경</li>
                    <li>비밀번호 변경</li>
                </ul>
            </div>
        </div>

        <main>
            <h1>비밀번호 변경</h1>
            <p>주기적인 <span class="highlight">비밀번호 변경</span>을 통해 개인정보를 안전하게 보호하세요.</p>

            <form action="#" method="post">
                <label for="new-password">새 비밀번호</label>
                <input type="password" id="new-password" name="new-password" required>

                <label for="confirm-password">새 비밀번호 확인</label>
                <input type="password" id="confirm-password" name="confirm-password" required>

                <p class="info">비밀번호는 6~16자 이내로 영문(대,소문자), 숫자, 특수문자 3가지 조합 중 2가지 이상을 조합하셔서 만드시면 됩니다.</p>

                <button type="submit" class="btn">변경하기</button>
            </form>
        </main>
    </div>
</div>
</body>
</html>
