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
                <br>
                <button type="button" id="checkUserBtn">유효성 검사</button>
                <span id="emailCheckResult"></span>
            </div>

            <div class="form-group">
                <input type="text" id="emailCode" name="emailCode" placeholder="Enter verification code" required>
                <br>
                <button type="button" id="sendEmailCodeBtn" disabled>이메일 인증</button>
                <button type="button" id="verifyEmailBtn" disabled>인증확인</button>
                <span id="emailCodeCheckResult"></span>
            </div>

            <button type="submit" class="btn-submit" id="emailSuccess" disabled>비밀번호 변경</button>
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

            <button type="submit" class="btn-submit" id="changePw" disabled>2차 인증 완료 후 비밀번호 변경</button>

        </div>

        <div class="form-footer">
            <a href="/login">로그인</a>
        </div>
    </form>
</div>

<script>
  $(document).ready(function() {
    let isIdValid = false;
    let isPasswordValid = false;
    let isEmailValid = false;
    let isEmailVerified = false;

    // 비밀번호 변경 버튼 활성화 유효성 검사
    function validateForm() {
      if (
          isIdValid && isEmailValid && isEmailVerified
      ) {
        $("#emailSuccess").prop("disabled", false).removeClass("disabled").addClass("active");
      } else {
        $("#emailSuccess").prop("disabled", true).removeClass("active").addClass("disabled");

      }
    }

    // 이메일 인증 완료 버튼 클릭 시 step1 숨기고 step2 표시
    $("#emailSuccess").click(function () {
      $("#step1").hide();  // step1 숨기기
      $("#emailSuccess").hide();
      $("#step2").show();  // step2 보이기
    });


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
          $('#emailCheckResult').text("사용자 정보가 확인되었습니다.").css("color", "green");
          isIdValid = true;
          isEmailValid = true;
          $('#sendEmailCodeBtn').prop('disabled', false); // 이메일 인증 버튼 활성화
        },
        error: function() {
          $('#emailCheckResult').text("아이디 또는 이메일이 일치하지 않습니다.").css("color", "red");
        }
      });
    });

    // 2단계 : 이메일 인증 및 인증 번호 검증
    $("#sendEmailCodeBtn").click(function() {
      let email = $("#email").val();

      // 버튼 비활성화 (한 번만 클릭 가능)
      $(this).prop("disabled", true);

      $.ajax({
        type: "POST",
        url: "/api/users/find-password/email-send",
        contentType: "application/json",
        data: JSON.stringify({ email: email }),
        success: function(response) {
          if (response.code === 200) {
            $("#emailCheckResult").text("이메일 인증 코드가 전송되었습니다.").css("color", "green");
            $("#verifyEmailBtn").prop("disabled", false); // 인증 확인 버튼 활성화
          } else {
            $("#emailCheckResult").text("이메일 인증 요청 실패.").css("color", "red");
          }
        }
      });
    });

    // 이메일 인증 코드 확인
    $("#verifyEmailBtn").click(function () {
      let email = $("#email").val();
      let code = $("#emailCode").val();

      $.ajax({
        type: "POST",
        url: "/api/users/verify-email",
        contentType: "application/json",
        data: JSON.stringify({ email: email, code: code }),
        success: function (response) {
          if (response.code === 200) {
            $("#emailCodeCheckResult").text("이메일 인증 완료!").css("color", "green");
            isEmailVerified = true; // 상태 업데이트
            console.log(isIdValid);
            console.log(isEmailVerified);
            console.log(isEmailValid);
            validateForm()
            // 비밀번호 변경 버튼 보이기
            $("#emailSuccess").show();
          } else {
            $("#emailCodeCheckResult").text("인증코드를 다시 확인해주세요").css("color", "red");
            isEmailVerified = false;
          }
        },
        error: function (xhr) {
          if (xhr.status === 400) {
            $("#emailCodeCheckResult").text("인증코드를 다시 확인해주세요").css("color", "red");
            isEmailVerified = false;
          } else {
            $("#emailCodeCheckResult").text("서버 오류가 발생했습니다. 다시 시도해주세요.").css("color", "red");
            isEmailVerified = false;
          }
        }
      });
    });

    // 3단계: 비밀번호 확인 및 검증
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

      if (isPasswordValid && isEmailVerified) {
        $('#changePw').prop('disabled', false);
      } else {
        $('#changePw').prop('disabled', true);
      }
    });

    // 4단계: 비밀번호 변경 요청
    $('#findPwForm').submit(function(event) {
      event.preventDefault();

      if ($("#changePw").prop("disabled")) {
        return; // 버튼이 비활성화되어 있으면 요청 중단
      }

      let email = $('#email').val();
      let newPassword = $('#newPassword').val();
      let confirmNewPassword = $('#confirmNewPassword').val();

      $.ajax({
        type: "POST",
        url: "/api/users/change-password",
        contentType: "application/json",
        data: JSON.stringify({ email: email, newPassword: newPassword, confirmNewPassword: confirmNewPassword }),
        success: function(response) {
          alert("비밀번호가 성공적으로 변경되었습니다. 로그인 페이지로 이동합니다.");
          window.location.href = "/login";
        },
        error: function(xhr) {
          let response = xhr.responseJSON;
          alert(response.errorMessage || "비밀번호 변경에 실패했습니다. 다시 시도하세요.");
        }
      });
    });

// 버튼 클릭 시 form 제출
    $('#changePw').click(function() {
      if (!$(this).prop("disabled")) {
        $('#findPwForm').submit();
      }
    });




  });

</script>
</body>
</html>
