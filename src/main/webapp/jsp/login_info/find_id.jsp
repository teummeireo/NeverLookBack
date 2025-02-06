<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Find Id</title>
    <link rel="stylesheet" href="/css/login_register_find.css">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<body>
<div class="signup-container">
    <form id="findIdForm" class="signup-form">
        <h2>아이디 찾기</h2>

        <div class="form-group">
            <input type="email" id="email" name="email" placeholder="등록된 이메일을 입력하세요" required>
            <span id="emailFindResult"></span>
        </div>

        <button type="submit" class="btn-submit">Next</button>

        <div class="form-footer">
            <a href="/login">로그인</a>
            <a href="/find-pw">비밀번호 찾기</a>
        </div>
    </form>
</div>

<!-- 모달 창 -->
<div id="findIdModal" class="modal" style="display:none;">
    <div class="modal-content">
        <span class="close-btn">&times;</span>
        <p>회원님의 아이디: <span id="foundLoginId"></span></p>
    </div>
</div>

<script>
  $(document).ready(function() {
    $('#findIdForm').submit(function(event) {
      event.preventDefault(); // 폼 기본 제출 방지

      var email = $('#email').val();

      $.ajax({
        type: "POST",
        url: "/api/users/find-id",
        contentType: "application/json",
        data: JSON.stringify({ email: email }),
        success: function(response) {
          $('#foundLoginId').text(response.data);
          $('#findIdModal').show();
          $('#emailFindResult').text("").hide();
        },
        error: function() {
          $('#emailFindResult').text("등록되지 않은 사용자입니다.").css("color", "red").show();
        }
      });
    });

    // 모달 닫기 기능
    $('.close-btn').click(function() {
      $('#findIdModal').hide();
    });
  });
</script>
</body>
</html>
