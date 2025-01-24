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
</div
        <!-- 모달 HTML -->
<div class="modal" id="confirmationModal">
  <div class="modal-content">
    <p>정말로 탈퇴하시겠습니까?</p>
    <button class="btn-confirm" id="confirmButton">확인</button>
    <button class="btn-cancel" id="cancelButton">취소</button>
  </div>
</div>

<script>
  // 모달 관련 JavaScript
  const deleteButton = document.getElementById('deleteButton');
  const modal = document.getElementById('confirmationModal');
  const confirmButton = document.getElementById('confirmButton');
  const cancelButton = document.getElementById('cancelButton');
  const signupForm = document.getElementById('signupForm');

  // "탈퇴하기" 버튼 클릭 시 모달 표시
  deleteButton.addEventListener('click', () => {
    modal.style.display = 'flex';
  });

  // "확인" 버튼 클릭 시 폼 제출
  confirmButton.addEventListener('click', () => {
    signupForm.submit();
  });

  // "취소" 버튼 클릭 시 모달 닫기
  cancelButton.addEventListener('click', () => {
    modal.style.display = 'none';
  });
</script>
</body>
</html>
