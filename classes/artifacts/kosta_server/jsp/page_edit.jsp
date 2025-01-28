<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <title>Title</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>회원정보 수정</title>
    <link rel="stylesheet" href="/css/page_edit.css">
</head>
<body>
<div class="top-buttons">
    <button onclick="goHome()">홈으로가기</button>
    <button onclick="logout()">로그아웃</button>
</div>
<div class="container">
    <div class="sidebar">
        <ul>
            <li id="nickname-btn" class="active" onclick="showNicknameChange()">닉네임 변경</li>
            <li id="password-btn" onclick="showPasswordChange()">비밀번호 변경</li>
        </ul>
    </div>
    <div class="content" id="content">
        <h1>닉네임 변경</h1>
        <div class="divider"></div>
        <p>새 닉네임을 입력하고 변경을 완료하세요.</p>
        <form>
            <div class="form-group">
                <label for="new-nickname">새 닉네임</label>
                <input type="text" id="new-nickname" placeholder="새 닉네임">
            </div>
            <button type="button" class="btn" onclick="handleNicknameChange()">변경하기</button>
        </form>
    </div>
</div>
<script>
    function goHome() {
        window.location.href = "main.jsp";
    }
    function logout() {
        window.location.href = "main.jsp"; //이부분 세션없이
    }
</script>
<script>
    // 닉네임 변경 화면 표시
    function showNicknameChange() {
        const content = document.getElementById("content");
        document.getElementById("nickname-btn").classList.add("active");
        document.getElementById("password-btn").classList.remove("active");

        content.innerHTML = `
            <h1>닉네임 변경</h1>
            <div class="divider"></div>
            <p><span  style="color: #b388ff; font-weight: bold;">새 닉네임</span>을 입력하고<br>변경을 완료하세요.</p>
            <form>
                <div class="form-group">
                    <label for="new-nickname">새 닉네임</label>
                    <input type="text" id="new-nickname" placeholder="새 닉네임">
                </div>
                <button class="btn">변경하기</button>
            </form>
        `;
    }

    // 비밀번호 변경 화면 표시
    function showPasswordChange() {
        const content = document.getElementById("content");
        document.getElementById("password-btn").classList.add("active");
        document.getElementById("nickname-btn").classList.remove("active");

        content.innerHTML = `
        <h1>비밀번호 변경</h1>
        <div class="divider"/></div>
        <p>주기적인 <span  style="color: #b388ff; font-weight: bold;">비밀번호 변경</span>을 통해<br>개인 정보를 안전하게 보호하세요.</p>
        <form>
            <div class="form-group">
                <label for="new-password">새 비밀번호</label>
                <input type="password" id="new-password" placeholder="새 비밀번호">
            </div>
            <div class="form-group">
                <label for="confirm-password">비밀번호 확인</label>
                <input type="password" id="confirm-password" placeholder="비밀번호 확인">
            </div>
                <button type="button" class="btn" onclick="handleNicknameChange()">변경하기</button>
        </form>
        <p style="font-size: 14px; color: #777; margin-top: 20px;">
            <span style="color: #b388ff; font-size: 18px; font-weight: bold;">ⓘ</span> 비밀번호는 6~16자 이내로 영문(대, 소문자), 숫자, 특수문자 3가지 조합 중<br>2가지 이상을 포함해야 합니다.
        </p>
`;
    }
    function handleNicknameChange() {
        alert("변경되었습니다!");
        document.getElementById("new-nickname").value = "";
    }

    function handlePasswordChange() {
        alert("변경되었습니다!");
        document.getElementById("new-password").value = "";
        document.getElementById("confirm-password").value = "";
    }
</script>
</body>
</html>