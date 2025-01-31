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

</head>
<body>
<div class="main-container">
    <%@ include file="../sidebar.jsp" %>

    <main class="content">
        <header class="header">
            <div class="search-bar">
                <input type="text" placeholder="Search (Ctrl+/)">
                <i class="icon-search"></i>
            </div>
            <h1>Admin Page</h1>
        </header>
        <section class="dashboard-grid">
            <div class="dashboard-card">
                <h3><a href = "/manage/exams">시험/답안 관리</a></h3>
            </div>

            <div class="dashboard-card project-list">
                <h3><a href="/admin/manage/users">사용자 계정 관리</a></h3>
            </div>
            <div class="dashboard-card project-list">
                <h3><a href="/admin/statistic/site">사용자 통계 조회</a></h3>
            </div>
        </section>
    </main>
</div>
</body>
</html>

