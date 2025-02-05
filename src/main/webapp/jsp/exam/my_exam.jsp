<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Main Dashboard</title>
    <link rel="stylesheet" href="/css/my_exam.css">
</head>
<body>
<div class="main-container">
    <%@ include file="/jsp/sidebar.jsp" %>

    <%--    sidebar랑 메인이랑 분리  --%>
    <main class="content">
        <header class="header">
            <div class="search-bar">
                <input type="text" placeholder="Search (Ctrl+/)">
                <i class="icon-search"></i>
            </div>
            <br>
            <h1>My exam Dashboard</h1>
        </header>
        <div class="divider"></div>
        <div class="dashboard-card project-list" onclick="location.href='${pageContext.request.contextPath}/jsp/exam/exam_result.jsp'" style="cursor: pointer;">
            <h3>이전 응시 내역</h3>
            <ul>
                <li>Project 1 - In Progress</li>
                <li>Project 2 - Completed</li>
                <li>Project 3 - Pending</li>
            </ul>
        </div>
        <div class="dashboard-card project-list" onclick="location.href='${pageContext.request.contextPath}/jsp/exam/exam_result.jsp'" style="cursor: pointer;">
            <h3>내 시험 답안 상세보기</h3>
            <ul>
                <li>Project 1 - In Progress</li>
                <li>Project 2 - Completed</li>
                <li>Project 3 - Pending</li>
            </ul>
        </div>
        <div class="dashboard-card project-list" onclick="location.href='${pageContext.request.contextPath}/jsp/exam/take_exam.jsp'" style="cursor: pointer;">
            <h3>시험 응시 바로가기</h3>
            <ul>
                <li>Project 1 - In Progress</li>
                <li>Project 2 - Completed</li>
                <li>Project 3 - Pending</li>
            </ul>
        </div>
    </main>
</div>
</body>
</html>