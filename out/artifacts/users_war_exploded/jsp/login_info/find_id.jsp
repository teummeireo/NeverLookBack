<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Find Id</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/login_register_find.css"> <!-- Link to your CSS file -->
</head>
<body>
<div class="signup-container">
    <form id="signupForm" class="signup-form">
        <h2>아이디 찾기</h2>

        <div class="form-group">
            <input type="email" id="email" name="email" placeholder="등록된 이메일을 입력하세요" required>
        </div>

        <div class="form-group">
            <input type="text" id="te" name="te" placeholder="여기에 이메일 인증번호 적는 거 넣어야함" required>
        </div>

        <button type="submit" class="btn-submit">Next</button>

        <div class="form-footer">
            <a href="/jsp/login_info/login.jspo/login.jsp">로그인</a> |
            <a href="/jsp/login_info/find_pw.jspfind_pw.jsp">비밀번호 찾기</a>
        </div>
    </form>
</div>

<script>


</script>
</body>
</html>
