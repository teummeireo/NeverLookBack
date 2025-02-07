<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Main Dashboard</title>
    <link rel="stylesheet" href="/css/my_exam.css">
    <link rel="stylesheet" href="/css/sidebar.css">

</head>
<body>
<div class="main-container">
    <%@ include file="/jsp/sidebar.jsp" %>
    <main class="content">
        <header class="header">
            <h1>응시한 시험</h1>
        </header>
        <div class="divider"></div>
        <div class="project-list">
            <div class="dashboard-card" onclick="location.href='${pageContext.request.contextPath}/jsp/exam/exam_result.jsp'">
                <div class="card-icon">
                    <i class="icon-history"></i> <!-- Replace with an actual icon -->
                </div>
                <h2>이전 응시 내역</h2>
                <p>이전에 응시한 시험 결과를 확인하세요.</p>
            </div>
            <div class="dashboard-card" onclick="location.href='${pageContext.request.contextPath}/jsp/exam/my_exam_detail.jsp'">
                <div class="card-icon">
                    <i class="icon-detail"></i> <!-- Replace with an actual icon -->
                </div>
                <h2>내 시험 답안 상세보기</h2>
                <p>내 시험 답안을 확인하고 복습해보세요.</p>
            </div>
            <div class="dashboard-card" onclick="location.href='${pageContext.request.contextPath}/jsp/exam/take_exam.jsp'">
                <div class="card-icon">
                    <i class="icon-exam"></i> <!-- Replace with an actual icon -->
                </div>
                <h2>시험 응시 바로가기</h2>
                <p>시험에 바로 응시할 수 있습니다.</p>
            </div>
        </div>
    </main>
</div>
</body>
</html>