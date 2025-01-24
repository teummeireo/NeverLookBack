<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/login_register_find.css"> <!-- Link to your CSS file -->
</head>
<body>
<div class="signup-container">
    <form id="signupForm" class="signup-form">
        <h2>Login</h2>

        <div class="form-group">
            <input type="text" id="id" name="id" placeholder="User" required>
        </div>

        <div class="form-group password-group">
            <input type="password" id="password" name="password" placeholder="Password" required>
        </div>

        <button type="submit" class="btn-submit">Login</button>

        <div class="form-footer">
            <a href="/jsp/find_id.jsp">아이디 찾기</a> |
            <a href="/jsp/find_pw.jsp">비밀번호 찾기</a>
        </div>

        <div class="form-footer">
            <a href="/jsp/register.jsp">회원가입</a>
        </div>

    </form>
</div>

<script>


</script>
</body>
</html>
