<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sign Up</title>
    <link rel="stylesheet" href="../css/login_register_find.css">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<body>
<div class="signup-container">
    <form id="signupForm" class="signup-form">
        <h2>Sign up</h2>

        <div class="form-group">
            <input type="text" id="loginId" name="loginId" placeholder="User ID" required>
            <button type="button" id="checkIdBtn" disabled>중복확인</button>
            <span id="idCheckResult"></span>
        </div>

        <div class="form-group password-group">
            <input type="password" id="password" name="password" placeholder="Password" required>
            <span id="passwordValidationResult"></span>
        </div>

        <div class="form-group password-group">
            <input type="password" id="confirmPassword" name="confirmPassword"
                   placeholder="Confirm Password" required>
            <span id="passwordMatchResult"></span>
        </div>

        <div class="form-group">
            <input type="text" id="nickname" name="nickname" placeholder="NickName" required>
            <button type="button" id="checkNicknameBtn" disabled>중복확인</button>
            <span id="nicknameCheckResult"></span>
        </div>

        <div class="form-group">
            <input type="email" id="email" name="email" placeholder="Email" required>
            <button type="button" id="checkEmailBtn" disabled>중복확인</button>
            <span id="emailCheckResult"></span>
        </div>

        <div class="form-group">
            <input type="text" id="emailCode" name="emailCode" placeholder="Enter verification code"
                   required>
            <button type="button" id="sendEmailCodeBtn" disabled>이메일 인증</button>
            <button type="button" id="verifyEmailBtn" disabled>인증확인</button>
            <span id="emailCodeCheckResult"></span>
        </div>


        <div class="form-group">
            <input type="text" id="userRole" name="userRole" placeholder="role" required>
            <span id="roleValidationResult"></span>
        </div>

        <button type="submit" class="btn-submit" id="registerBtn" disabled>Join</button>

        <div class="form-footer">
            <a href="/jsp/login_info/login.jsp">Login</a>
        </div>
    </form>
</div>

<script>
  $(document).ready(function () {
    let isIdAvailable = false;
    let isNicknameAvailable = false;
    let isPasswordMatching = false;
    let isIdValid = false;
    let isNicknameValid = false;
    let isPasswordValid = false;
    let isRoleValid = false;
    let isEmailValid = false;
    let isEmailAvailable = false;
    let isEmailVerified = false;

    const idRegex = /^[a-zA-Z0-9]{4,16}$/;
    const nicknameRegex = /^[a-zA-Z0-9]{2,6}$/;
    const passwordRegex = /^[a-zA-Z0-9!@#$%^&*()]{6,16}$/;
    // 이메일은 3글자 이상의 TLD만 허용한다.
    const emailRegex = /^[^\s@]+@[^\s@]+\.[a-zA-Z]{3,}$/;

    // Join 버튼 활성화 유효성 검사
    function validateForm() {
      if (
          isIdValid && isIdAvailable &&
          isNicknameValid && isNicknameAvailable &&
          isPasswordValid && isPasswordMatching &&
          isRoleValid &&
          isEmailValid && isEmailAvailable && isEmailVerified
      ) {
        $("#registerBtn").prop("disabled", false).removeClass("disabled").addClass("active");
      } else {
        $("#registerBtn").prop("disabled", true).removeClass("active").addClass("disabled");
      }
    }

    // 아이디 입력 시 유효성 검사 + 중복 검사 상태 초기화
    $("#loginId").on("input", function () {
      let loginId = $(this).val();
      if (idRegex.test(loginId)) {
        $("#idCheckResult").text("유효한 아이디입니다.").css("color", "green");
        isIdValid = true;
        $("#checkIdBtn").prop("disabled", false);
      } else {
        $("#idCheckResult").text("아이디는 4~16자의 영문, 숫자만 가능합니다.").css("color", "red");
        isIdValid = false;
        $("#checkIdBtn").prop("disabled", true);
      }
      isIdAvailable = false;
      validateForm();
    });

    // 닉네임 입력 시 유효성 검사 + 중복 검사 상태 초기화
    $("#nickname").on("input", function () {
      let nickname = $(this).val();
      if (nicknameRegex.test(nickname)) {
        $("#nicknameCheckResult").text("유효한 닉네임입니다.").css("color", "green");
        isNicknameValid = true;
        $("#checkNicknameBtn").prop("disabled", false);
      } else {
        $("#nicknameCheckResult").text("닉네임은 2~6자의 영문, 숫자만 가능합니다.").css("color", "red");
        isNicknameValid = false;
        $("#checkNicknameBtn").prop("disabled", true);
      }
      isNicknameAvailable = false;
      validateForm();
    });

    // 비밀번호 입력 시 유효성 검사
    $("#password").on("input", function () {
      let password = $(this).val();
      if (passwordRegex.test(password)) {
        $("#passwordValidationResult").text("유효한 비밀번호입니다.").css("color", "green");
        isPasswordValid = true;
      } else {
        $("#passwordValidationResult").text("비밀번호는 6~16자의 영문, 숫자, 특수문자만 가능합니다.").css("color",
            "red");
        isPasswordValid = false;
      }
      validateForm();
    });

    // 비밀번호 확인
    $("#confirmPassword").on("input", function () {
      let password = $("#password").val();
      let confirmPassword = $(this).val();
      if (password === confirmPassword) {
        $("#passwordMatchResult").text("비밀번호가 일치합니다.").css("color", "green");
        isPasswordMatching = true;
      } else {
        $("#passwordMatchResult").text("비밀번호가 일치하지 않습니다.").css("color", "red");
        isPasswordMatching = false;
      }
      validateForm();
    });

    // 역할(userRole) 입력 시 유효성 검사
    $("#userRole").on("input", function () {
      let role = $(this).val().toLowerCase();
      if (role === "user" || role === "admin") {
        $("#roleValidationResult").text("유효한 역할입니다.").css("color", "green");
        isRoleValid = true;
      } else {
        $("#roleValidationResult").text("역할은 'user' 또는 'admin'만 가능합니다.").css("color", "red");
        isRoleValid = false;
      }
      validateForm();
    });

    // 아이디 중복 확인
    $("#checkIdBtn").click(function () {
      let loginId = $("#loginId").val();
      if (!isIdValid) {
        alert("아이디 형식을 확인하세요.");
        return;
      }
      $.ajax({
        type: "GET",
        url: "/api/users/check-id",
        data: {loginId: loginId},
        success: function () {
          $("#idCheckResult").text("사용 가능한 아이디입니다.").css("color", "green");
          isIdAvailable = true;
          validateForm();
        },
        error: function (response) {
          $("#idCheckResult").text("이미 존재하는 아이디입니다.").css("color", "red");
          isIdAvailable = false;
          validateForm();
        }
      });
    });

    // 닉네임 중복 확인
    $("#checkNicknameBtn").click(function () {
      let nickname = $("#nickname").val();
      if (!isNicknameValid) {
        alert("닉네임 형식을 확인하세요.");
        return;
      }
      $.ajax({
        type: "GET",
        url: "/api/users/check-nickname",
        data: {nickname: nickname},
        success: function () {
          $("#nicknameCheckResult").text("사용 가능한 닉네임입니다.").css("color", "green");
          isNicknameAvailable = true;
          validateForm();
        },
        error: function (response) {
          $("#nicknameCheckResult").text("이미 존재하는 닉네임입니다.").css("color", "red");
          isNicknameAvailable = false;
          validateForm();
        }
      });
    });

    // 이메일 중복 확인
    $("#checkEmailBtn").click(function () {
      let email = $("#email").val();
      if (!isEmailValid) {
        alert("이메일 형식을 확인하세요.");
        return;
      }
      $.ajax({
        type: "GET",
        url: "/api/users/check-email",
        data: {email: email},
        success: function () {
          $("#emailCheckResult").text("사용 가능한 이메일입니다.").css("color", "green");
          isEmailAvailable = true;
          $("#sendEmailCodeBtn").prop("disabled", false); // 이메일 인증 버튼 활성화 추가
          validateForm();
        },
        error: function (response) {
          $("#emailCheckResult").text("이미 존재하는 이메일입니다.").css("color", "red");
          isEmailAvailable = false;
          $("#sendEmailCodeBtn").prop("disabled", true); // 이미 존재하면 비활성화 유지
          validateForm();
        }
      });
    });

    // 이메일 입력 시 유효성 검사 및 초기화
    $("#email").on("input", function () {
      let email = $(this).val();
      if (emailRegex.test(email)) {
        $("#emailCheckResult").text("올바른 이메일 형식입니다.").css("color", "green");
        isEmailValid = true;
        $("#checkEmailBtn").prop("disabled", false);
      } else {
        $("#emailCheckResult").text("이메일 형식이 올바르지 않습니다.").css("color", "red");
        isEmailValid = false;
        $("#checkEmailBtn").prop("disabled", true);
      }
      isEmailAvailable = false;
      isEmailVerified = false;
      $("#sendEmailCodeBtn").prop("disabled", true);
      $("#verifyEmailBtn").prop("disabled", true);
      validateForm();
    });

    // 이메일 인증 코드 전송
    $("#sendEmailCodeBtn").click(function () {
      let email = $("#email").val();
      $.ajax({
        type: "POST",
        url: "/api/users/send-email",
        contentType: "application/json",
        data: JSON.stringify({email: email}),
        success: function (response) {
          if (response.code === 200) {
            $("#emailCheckResult").text("이메일 인증 코드가 전송되었습니다.").css("color", "green");
            $("#verifyEmailBtn").prop("disabled", false);
            validateForm();
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

      // 인증 코드 확인 요청
      $.ajax({
        type: "POST",
        url: "/api/users/verify-email",
        contentType: "application/json",
        data: JSON.stringify({email: email, code: code}),
        success: function (response) {
          if (response.code === 200) {
            // 인증 성공
            $("#emailCodeCheckResult").text("이메일 인증 완료!").css("color", "green");
            isEmailVerified = true; // 상태 업데이트
            validateForm(); // Join 버튼 활성화 검사
          } else {
            // 인증 실패 (응답 코드가 200이 아닌 경우 처리)
            $("#emailCodeCheckResult").text("인증코드를 다시 확인해주세요").css("color", "red");
            isEmailVerified = false; // 상태 초기화
            validateForm(); // Join 버튼 비활성화 검사
          }
        },
        error: function (xhr) {
          // 400 에러 처리
          if (xhr.status === 400) {
            $("#emailCodeCheckResult").text("인증코드를 다시 확인해주세요").css("color", "red");
            isEmailVerified = false; // 상태 초기화
            validateForm(); // Join 버튼 비활성화 검사
          } else {
            // 서버 오류 처리
            $("#emailCodeCheckResult").text("서버 오류가 발생했습니다. 다시 시도해주세요.").css("color", "red");
            isEmailVerified = false; // 상태 초기화
            validateForm(); // Join 버튼 비활성화 검사
          }
        },
      });
    });

    // 회원가입 버튼 활성화 시 이벤트
    $("#signupForm").submit(function (event) {
      event.preventDefault(); // 기본 폼 제출 방지

      let userData = {
        loginId: $("#loginId").val(),
        password: $("#password").val(),
        nickname: $("#nickname").val(),
        email: $("#email").val(),
        userRole: $("#userRole").val()
      };

      $.ajax({
        type: "POST",
        url: "/api/users/register",
        contentType: "application/json",
        data: JSON.stringify(userData),
        success: function (response, status, xhr) {
          if (xhr.status === 201) { // 서버에서 201 Created 응답 확인
            alert("회원가입이 완료되었습니다!");
            window.location.href = "/jsp/login_info/login.jsp"; // 로그인 페이지로 이동
          } else {
            alert("회원가입에 실패했습니다. 다시 시도해주세요.");
          }
        },
        error: function (xhr) {
          if (xhr.status === 400) {
            alert("입력 데이터를 확인해주세요. 회원가입에 실패했습니다.");
          } else if (xhr.status === 500) {
            alert("서버 오류가 발생했습니다.");
          } else {
            alert("회원가입 중 문제가 발생했습니다.");
          }
        }
      });
    });

  });
</script>


</body>
</html>
