<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title></title>
  <link rel="stylesheet" href="../css/unregister_user.css">
</head>
<body>
<div class="signup-container">
  <form id="signupForm" class="signup-form">
    <h2>회원 탈퇴</h2>
  <br><br>
    <div class="form-group">
      <input type="text" id="id" name="id" placeholder="User" required>
    </div>

    <div class="form-group password-group">
      <input type="password" id="password" name="password" placeholder="Password" required>
    </div>
    <br>
    <button type="submit" class="btn-submit">탈퇴하기</button>

  </form>
</div>
</body>
</html>
