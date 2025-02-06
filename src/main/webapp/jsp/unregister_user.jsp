<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="../css/unregister_user.css">
    <!-- SweetAlert2 CSS -->
    <script src="http://code.jquery.com/jquery-latest.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@10"></script>
    <!-- Bootstrap CSS (선택사항) -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet"
          integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous"/>
</head>
<body>
<div class="signup-container">
    <form id="signup-form" class="signup-form">
        <h2>회원 탈퇴</h2>
        <br><br>
        <div class="form-group">
            <input type="text" id="id" name="id" placeholder="User" required>
        </div>
        <div class="form-group password-group">
            <input type="password" id="password" name="password" placeholder="Password" required>
        </div>
        <br>
        <button type="button" class="btn-submit" id="confirmUnregister">탈퇴하기</button>
    </form>
</div>

<script>
    $("#confirmUnregister").click(function () {
        Swal.fire({
            title: '정말로 탈퇴하시겠습니까?',
            text: "이 작업은 되돌릴 수 없습니다. 신중하게 결정하세요.",
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#3085d6',
            cancelButtonColor: '#d33',
            confirmButtonText: '탈퇴',
            cancelButtonText: '취소',
            reverseButtons: true, // 버튼 순서 반전
        }).then((result) => {
            if (result.isConfirmed) {
                const loginId = $("#id").val(); // 사용자 ID 가져오기
                const password = $("#password").val(); // 비밀번호 가져오기
                const userId = "${sessionScope.userId}";

                // REST API 호출
                $.ajax({
                    url: "/api/users/deactivate",
                    method: 'PUT',
                    contentType: "application/json",
                    data: JSON.stringify({
                        userId: userId,
                        loginId: loginId,
                        password: password
                    }),
                    success: function (response) {
                        Swal.fire(
                            '탈퇴 완료',
                            '회원 탈퇴가 성공적으로 처리되었습니다.',
                            'success'
                        ).then(() => {
                            // main.jsp로 이동
                            window.location.href = '/logout';
                        });
                    },
                    error: function (xhr, status, error) {
                        Swal.fire(
                            '탈퇴 실패',
                            xhr.responseJSON.message || '회원 탈퇴 중 오류가 발생했습니다.',
                            'error'
                        );
                    }
                });
            }
        });
    });
</script>
</body>
</html>