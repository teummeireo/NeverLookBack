<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Main Dashboard</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/sidebar.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css">


</head>
<body>
<div class="main-container">
    <%@ include file="../sidebar.jsp" %>
    <main class="content">
        <div class="header">
            <h1>Admin</h1>
        </div>
        <div class="divider"></div>
        <section class="dashboard-grid">
            <a href="/admin/manage/exams" class="dashboard-card">시험/답안 관리</a>
            <a href="/admin/manage/users" class="dashboard-card">사용자 계정 관리</a>
            <a href="/admin/statistic/site" class="dashboard-card">사용자 통계 조회</a>
        </section>
    </main>
</div>
</body>
</html>

