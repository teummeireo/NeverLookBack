<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sign Up</title>
    <link rel="stylesheet" href="/css/login_register_find.css"> <!-- Link to your CSS file -->
</head>
<body>
<div class="signup-container">
    <form id="signupForm" class="signup-form">
        <h2>Sign up</h2>

        <div class="form-group">
            <input type="text" id="id" name="id" placeholder="User" required>
        </div>

        <div class="form-group password-group">
            <input type="password" id="password" name="password" placeholder="Password" required>
        </div>

        <div class="form-group password-group">
            <input type="password" id="confirmPassword" name="confirmPassword" placeholder="Confirm Password" required>
        </div>

        <div class="form-group">
            <input type="text" id="nickname" name="nickname" placeholder="NickName" required>
        </div>

        <div class="form-group">
            <input type="email" id="email" name="email" placeholder="Email" required>
        </div>

        <div class="form-group">
            <input type="text" id="te" name="te" placeholder="여기에 이메일 인증번호 적는 거 넣어야함" required>
        </div>

        <button type="submit" class="btn-submit">Join</button>

        <div class="form-footer">
            <a href="/jsp/login.jsp">Login</a>
        </div>
    </form>
</div>

<script>


</script>
</body>
</html>
