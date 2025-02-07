<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login</title>
    <link rel="stylesheet" href="/css/login_register_find.css">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<body>
<div class="signup-container">
    <form id="loginForm" class="signup-form">
        <h2>Login</h2>

        <div class="form-group">
            <input type="text" id="loginId" name="loginId" placeholder="User" required>
        </div>

        <div class="form-group password-group">
            <input type="password" id="password" name="password" placeholder="Password" required>
        </div>

        <button type="submit" class="btn-submit">Login</button>

        <p id="error-message" style="color: red; display: none;">로그인 실패. 아이디 또는 비밀번호를 확인하세요.</p>

        <div class="form-footer">
            <a href="/find_id">아이디 찾기</a>
            <a href="/find_pw">비밀번호 찾기</a>
        </div>

        <div class="form-footer">
            <a href="/register">회원가입</a>
        </div>
    </form>
</div>

<script>
  $(document).ready(function() {
    $('#loginForm').submit(function(event) {
      event.preventDefault(); // 폼 기본 제출 방지

      var loginData = {
        loginId: $('#loginId').val(),
        password: $('#password').val()
      };

      $.ajax({
        type: "POST",
        url: "/api/users/login",
        contentType: "application/json",
        data: JSON.stringify(loginData),
        success: function(response) {
          // 로그인 성공 시 로컬스토리지에 userId 저장
          localStorage.setItem("userId", response.userId);
          localStorage.setItem("nickname", response.nickname);

          // 로그인 후 /login 페이지로 이동하여 세션 검증 후 메인 페이지로 리다이렉트
          window.location.href = "/";
        },
        error: function() {
          $('#error-message').show();
        }
      });
    });
  });
</script>
</body>
</html>