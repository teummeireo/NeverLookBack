<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>사용자 계정 관리</title>
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/manage_user.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/sidebar.css">
</head>
<body>
<div class="main-container">
    <%@ include file="/jsp/sidebar.jsp" %>
    <main class="content">
        <div class="container">
            <div class="header">
                <h1>User Admin</h1>
            </div>
            <table id="userTable" border="1">
                <thead>
                <tr>
                    <th>로그인 ID</th>
                    <th>닉네임</th>
                    <th>이메일</th>
                    <th>User role</th>
                    <th>User delete</th>
                    <th>활성화 여부</th>
                </tr>
                </thead>
                <tbody>
                <!-- 데이터가 여기에 동적으로 추가됨 -->
                </tbody>
            </table>
        </div>
    </main>
</div>

<script>
    $(document).ready(function() {
        loadUserList();
    });

    function loadUserList() {
        $.ajax({
            url: "${pageContext.request.contextPath}/api/admin/users",
            type: "GET",
            dataType: "json",
            headers: {
                "Accept": "application/json"
            },
            success: function(response) {
                let users = response.data;
                let tableBody = "";

                users.forEach(function(user) {
                    let statusClass = user.active === true ? "status-active" : "status-inactive"; // 클래스 적용
                    let statusText = user.active === true ? "활성화" : "비활성화"; // 텍스트 설정
                    tableBody += "<tr>" +
                        "<td>" + user.loginId + "</td>" +
                        "<td>" + user.nickname + "</td>" +
                        "<td>" + user.email + "</td>" +
                        "<td>" +
                        "<select class='user-role-select' id='user-role-select'  data-user-id='" + user.userId + "'>" +
                        "<option value='" + user.userRole + "' selected>" + user.userRole + "</option>" + // 기존 역할 유지
                        (user.userRole !== "admin" ? "<option value='ADMIN'>admin</option>" : "") +
                        (user.userRole !== "user" ? "<option value='USER'>user</option>" : "") +
                        "</select>" +
                        "</td>" +
                        "<td>" +
                        "<button class='delete-user-btn' data-user-id='" + user.userId + "'>" +
                        "Delete" +
                        "</button>" +
                        "</td>" +
                        "<td class='" + statusClass + "'>" + statusText + "</td>" + // 활성화 여부 색상 추가
                        "</tr>";
                });

            // 역할 변경 이벤트 바인딩
                $(document).on("change", ".user-role-select", function() {
                    var userId = $(this).data("user-id");
                    var newRole = $(this).val();
                    updateUserRole(userId, newRole);
                });

                document.querySelector("#userTable tbody").innerHTML = tableBody;
                // 삭제 버튼 클릭 이벤트 바인딩
                var deleteButtons = document.querySelectorAll(".delete-user-btn");
                deleteButtons.forEach(function(button) {
                    button.addEventListener("click", function () {
                        var userId = this.getAttribute("data-user-id");
                        deleteUser(userId); // 삭제 요청 함수 호출
                    });
                });
            },
            error: function(xhr, status, error) {
                console.error("사용자 목록을 불러오는 중 오류 발생:", error);
            }
        });
    }
    function deleteUser(userId) {
        if (confirm("정말로 이 사용자를 삭제하시겠습니까?")) {
            $.ajax({
                url: "/api/admin/users/" + userId + "?isActive=false", // URL에 직접 추가
                method: 'PUT',
                contentType: "application/x-www-form-urlencoded",
                success: function(response) {
                    alert("사용자가 비활성화되었습니다.");
                    loadUserList(); // 테이블 갱신
                },
                error: function(xhr, status, error) {
                    console.error("사용자를 삭제하는 중 오류 발생:", error);
                    alert("사용자 삭제 중 오류가 발생했습니다.");
                }
            });
        }
    }

    function updateUserRole(userId, newRole) {
        console.log("역할변경 : userid", userId, "newrole = ", newRole);
        $.ajax({
            url: "/api/admin/users/role/" + userId + "?role=" + newRole,  // API 요청 URL
            method: "PUT",
            contentType: "application/x-www-form-urlencoded",
            success: function(response) {
                console.log("역할 변경 성공:", response); // 응답 데이터 확인
                alert("사용자 역할이 변경되었습니다."); // 알림 추가
                loadUserList(); // UI 갱신
            },
            error: function(xhr, status, error) {
                console.error("역할 변경 중 오류 발생:", error);
                alert("사용자 역할 변경 중 오류가 발생했습니다."); // 오류 시 알림 표시
            }
        });
    }


</script>
</body>
</html>