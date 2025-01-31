<%--<%@ page language="java" contentType="text/html; charset=UTF-8"--%>
<%--         pageEncoding="UTF-8"%>--%>
<%--<!DOCTYPE html>--%>
<%--<html lang="ko">--%>
<%--<head>--%>
<%--    <meta charset="UTF-8">--%>
<%--    <title>사용자 계정 관리</title>--%>
<%--    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>--%>
<%--    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/submission_check.css">--%>
<%--    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/sidebar.css">--%>
<%--</head>--%>
<%--<body>--%>
<%--<div class="main-container">--%>
<%--    <%@ include file="/jsp/sidebar.jsp" %>--%>
<%--    <main class="content">--%>
<%--        <div class="container">--%>
<%--            <div class="header">--%>
<%--                <h1>User admin</h1>--%>
<%--            </div>--%>
<%--            <table border="1">--%>
<%--                <thead>--%>
<%--                <tr>--%>
<%--                    <th>로그인 ID</th>--%>
<%--                    <th>닉네임</th>--%>
<%--                    <th>이메일</th>--%>
<%--                    <th>User_role</th>--%>
<%--                </tr>--%>
<%--                </thead>--%>

<%--            </table>--%>
<%--        </div>--%>
<%--    </main>--%>
<%--</div>--%>



<%--<script src="https://code.jquery.com/jquery-3.7.1.js"></script>--%>
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
<%--</body>--%>
<%--</html>--%>