<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Find Password</title>
    <link rel="stylesheet" href="/css/login_register_find.css">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<body>
<div class="signup-container">
    <form id="findPwForm" class="signup-form">
        <h2>비밀번호 찾기</h2>

        <!-- 1단계: 아이디 + 이메일 입력 -->
        <div id="step1">
            <div class="form-group">
                <input type="text" id="loginId" name="loginId" placeholder="아이디 입력" required>
            </div>

            <div class="form-group">
                <input type="email" id="email" name="email" placeholder="이메일 입력" required>
                <button type="button" id="checkUserBtn">유효성 검사</button>
                <span id="emailCheckResult"></span>
            </div>
        </div>

        <!-- 2단계: 새 비밀번호 입력 -->
        <div id="step2" style="display: none;">
            <div class="form-group">
                <input type="password" id="newPassword" name="newPassword" placeholder="새 비밀번호 입력" required>
            </div>

            <div class="form-group">
                <input type="password" id="confirmNewPassword" name="confirmNewPassword" placeholder="비밀번호 확인" required>
                <span id="passwordMatchResult"></span>
            </div>

            <button type="submit" class="btn-submit" disabled>비밀번호 변경</button>
        </div>

        <div class="form-footer">
            <a href="/login">로그인</a>
        </div>
    </form>
</div>

<script>
  $(document).ready(function() {
    let isUserValid = false;
    let isPasswordValid = false;

    // 1단계: 아이디 + 이메일 유효성 검사
    $('#checkUserBtn').click(function() {
      let loginId = $('#loginId').val();
      let email = $('#email').val();

      $.ajax({
        type: "POST",
        url: "/api/users/find-password",
        contentType: "application/json",
        data: JSON.stringify({ loginId: loginId, email: email }),
        success: function() {
          $('#emailCheckResult').text("사용자 정보가 확인되었습니다. 비밀번호를 재설정하세요.").css("color", "green");
          isUserValid = true;
          $('#step1').hide();
          $('#step2').show();
          checkSubmitButton();
        },
        error: function(xhr) {
          $('#emailCheckResult').text("아이디 또는 이메일이 일치하지 않습니다.").css("color", "red");
          isUserValid = false;
          checkSubmitButton();
        }
      });
    });

    // 2단계: 비밀번호 확인 및 검증
    $('#newPassword, #confirmNewPassword').on('input', function() {
      let newPassword = $('#newPassword').val();
      let confirmNewPassword = $('#confirmNewPassword').val();

      if (newPassword.length < 6 || newPassword.length > 16) {
        $('#passwordMatchResult').text("비밀번호는 6~16자로 입력하세요.").css("color", "red");
        isPasswordValid = false;
      } else if (newPassword !== confirmNewPassword) {
        $('#passwordMatchResult').text("비밀번호가 일치하지 않습니다.").css("color", "red");
        isPasswordValid = false;
      } else {
        $('#passwordMatchResult').text("비밀번호 확인 완료!").css("color", "green");
        isPasswordValid = true;
      }

      checkSubmitButton();
    });

    // 3단계: 모든 조건 충족 시 "비밀번호 변경" 버튼 활성화
    function checkSubmitButton() {
      if (isUserValid && isPasswordValid) {
        $('.btn-submit').prop('disabled', false);
      } else {
        $('.btn-submit').prop('disabled', true);
      }
    }

    // 4단계: 비밀번호 변경 요청
    $('#findPwForm').submit(function(event) {
      event.preventDefault();

      let email = $('#email').val();
      let newPassword = $('#newPassword').val();
      let confirmNewPassword = $('#confirmNewPassword').val();

      $.ajax({
        type: "POST",
        url: "/api/users/find-password/send-email",
        contentType: "application/json",
        data: JSON.stringify({ email: email, newPassword: newPassword, confirmNewPassword: confirmNewPassword }),
        success: function(response) {
          alert("비밀번호가 성공적으로 변경되었습니다. 로그인 페이지로 이동합니다.");
          window.location.href = "/jsp/login_info/login.jsp";
        },
        error: function(xhr) {
          let response = xhr.responseJSON;
          alert(response.errorMessage || "비밀번호 변경에 실패했습니다. 다시 시도하세요.");
        }
      });
    });
  });
</script>
</body>
</html>
