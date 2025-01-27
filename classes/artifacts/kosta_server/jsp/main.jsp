<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Main Dashboard</title>
    <link rel="stylesheet" href="../css/main.css">
</head>
<body>
<div class="main-container">
    <aside class="sidebar">
        <h2>NeverLookBack</h2>
        <ul>
            <li><a href="/jsp/main.jsp">메인페이지</a></li>
            <li><a href="/jsp/make_exam.jsp">시험생성</a></li>
            <li><a href="/jsp/exam_apply.jsp">시험응시</a></li>
            <li><a href="/jsp/manageExam.jsp">시험관리</a></li>
            <li><a href="/jsp/exam.jsp">응시한 시험</a></li>
            <li><a href="/jsp/my_page.jsp">마이페이지</a></li>
            <li><a href="/jsp/logout.jsp">로그아웃</a></li>
        </ul>
    </aside>
    <main class="content">
        <header class="header">
            <div class="search-bar">
                <input type="text" placeholder="Search (Ctrl+/)">
                <i class="icon-search"></i>
            </div>
            <h1>Dashboard Analytics</h1>
        </header>
        <section class="dashboard-grid">
            <div class="dashboard-card">
                <h3>Statistics</h3>
                <p>Some detailed statistics...</p>
            </div>
            <div class="dashboard-card">
                <h3>Source Visits</h3>
                <p>Visit breakdown...</p>
            </div>
            <div class="dashboard-card project-list">
                <h3>Project List</h3>
                <ul>
                    <li>Project 1 - In Progress</li>
                    <li>Project 2 - Completed</li>
                    <li>Project 3 - Pending</li>
                </ul>
            </div>
            <div class="dashboard-card project-list">
                <h3>Project List</h3>
                <ul>
                    <li>Project 1 - In Progress</li>
                    <li>Project 2 - Completed</li>
                    <li>Project 3 - Pending</li>
                </ul>
            </div>
            <div class="dashboard-card project-list">
                <h3>Project List</h3>
                <ul>
                    <li>Project 1 - In Progress</li>
                    <li>Project 2 - Completed</li>
                    <li>Project 3 - Pending</li>
                </ul>
            </div>
            <div class="dashboard-card project-list">
                <h3>Project List</h3>
                <ul>
                    <li>Project 1 - In Progress</li>
                    <li>Project 2 - Completed</li>
                    <li>Project 3 - Pending</li>
                </ul>
            </div>
        </section>
    </main>
</div>
</body>
</html>

