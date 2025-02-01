<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>사용자 계정 관리</title>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <link rel="icon" href="${pageContext.request.contextPath}/favicon.ico" type="image/x-icon">
    <link rel="apple-touch-icon" href="${pageContext.request.contextPath}/apple-touch-icon.png">

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/submission_check.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/sidebar.css">
</head>
<body>
<div class="main-container">
    <%@ include file="/jsp/sidebar.jsp" %>
    <main class="content">
        <div class="container">
            <div class="header">
                <h1>User admin</h1>
            </div>
            <table border="1">
                <thead>
                <tr>
                    <th>로그인 ID</th>
                    <th>닉네임</th>
                    <th>이메일</th>
                    <th>User_role</th>
                </tr>
                </thead>
                <tbody id="resultTableBody">
                <!-- 여기에 데이터가 동적으로 추가됨요 -->
                </tbody>
            </table>
        </div>
    </main>
</div>

<script src="https://code.jquery.com/jquery-3.7.1.js"></script>
<script>
        $(document).ready(function() {
        loadUserList();
    });

        function loadUserList() {
        $.ajax({
            url: "${pageContext.request.contextPath}/api/users",
            type: "GET",
            dataType: "json",
            success: function(data) {
                let tableBody = "";
                data.forEach(user => {
                    tableBody += "<tr>" +
                        "<td>" + user.userId + "</td>" +
                        "<td>" + user.nickname + "</td>" +
                        "<td>" + user.email + "</td>" +
                        "<td>" + user.userRole + "</td>" +
                        "</tr>";
                });
                $("#userTable tbody").html(tableBody);
            },
            error: function(xhr, status, error) {
                console.error("사용자 목록을 불러오는 중 오류 발생:", error);
            }
        });
    }
</script>

<script>
    $(document).ready(function () {
        fetchResults(); // 페이지가 로드되자마자 데이터 가져오기
        $.ajax({
            url: "/api/admin/users",
            method: 'GET',
            dataType: "json",
            success: function (obj) {
                console.log("응답:" + obj);
            },
            error: function (xhr, status, error) {
                console.log("에러:", status);
                alert(xhr.responseJSON.error);
            }
        });

        // 회원 비활성화(삭제)
        $("#delete-user-btn").click( function() {
            //userId = ~~~
            $.ajax({
                url: "/api/admin/users/" + userId,
                method: 'PUT',
                data: "isActive=false",
                dataType: "json",
                success: function(obj) {
                    console.log("응답:" + obj);
                },
                error: function(xhr, status, error) {
                    console.log("에러:", status);
                    alert(xhr.responseJSON.error);
                }
            });
        });
    });
</script>
</body>
</html>