<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>사용자 계정 관리</title>
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/submission_check.css">
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
                    <th>User_role</th>
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
                users.forEach(user => {
                    tableBody += "<tr>" +
                        "<td>" + user.loginId + "</td>" +
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
</body>
</html>
<%--<script>--%>
<%--    $(document).ready(function () {--%>
<%--        fetchResults(); // 페이지가 로드되자마자 데이터 가져오기--%>
<%--        $.ajax({--%>
<%--            url: "/api/admin/users",--%>
<%--            method: 'GET',--%>
<%--            dataType: "json",--%>
<%--            success: function (obj) {--%>
<%--                console.log("응답:" + obj);--%>
<%--            },--%>
<%--            error: function (xhr, status, error) {--%>
<%--                console.log("에러:", status);--%>
<%--                alert(xhr.responseJSON.error);--%>
<%--            }--%>
<%--        });--%>

<%--        // 회원 비활성화(삭제)--%>
<%--        $("#delete-user-btn").click( function() {--%>
<%--            //userId = ~~~--%>
<%--            $.ajax({--%>
<%--                url: "/api/admin/users/" + userId,--%>
<%--                method: 'PUT',--%>
<%--                data: "isActive=false",--%>
<%--                dataType: "json",--%>
<%--                success: function(obj) {--%>
<%--                    console.log("응답:" + obj);--%>
<%--                },--%>
<%--                error: function(xhr, status, error) {--%>
<%--                    console.log("에러:", status);--%>
<%--                    alert(xhr.responseJSON.error);--%>
<%--                }--%>
<%--            });--%>
<%--        });--%>
<%--    });--%>
<%--</script>--%>
</body>
</html>