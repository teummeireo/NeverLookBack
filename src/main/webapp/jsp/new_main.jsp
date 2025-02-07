<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>NeverLookBack</title>
    <link rel="stylesheet" href="../css/new_main.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/sidebar.css">
</head>
<body>
<script>
    console.log("id : " + ${sessionScope.userId} )
</script>
<!-- 사이드바 포함 -->
<%@ include file="sidebar.jsp" %>

<main class="content">
    <section class="hero">
        <div class="hero-text">
            <h1>NeverLookBack</h1>
            <p>NeverLookBack은 누구나 온라인 시험을 손쉽게 제작, 배포, 인증, 수집,<br>자동 채점 및 결과 분석할 수 있는 개방형 시험 플랫폼입니다.<br>
            <br>NeverLookBack 서비스는 부정행위를 방지하기 위해 뒤돌아보지 말라는 의미와 함께,<br>실력을 발전시키기 위해 앞으로 나아가라는 중의적인 메시지를 담고 있습니다. </p>
            <a href="/exams/init-exam" class="btn">Create your tests for free</a>
        </div>
        <div class="hero-image">
            <img src="../images/main_img.png" alt="NLB demonstration"> <!-- 이미지 URL을 여기에 추가 -->
        </div>
    </section>

    <section class="poll-types">
        <div class="poll-type">
            <img src="../images/v2-multiple-choice.677ae516.svg" alt="Multiple choice icon"> <!-- 아이콘 URL -->
            <span>Multiple choice</span>
        </div>
        <div class="poll-type">
            <img src="../images/v2-wordcloud.41258620.svg" alt="Word cloud icon">
            <span>Word cloud</span>
        </div>
        <div class="poll-type">
            <img src="../images/v2-quiz.3d63620f.svg" alt="Quiz icon">
            <span>Quiz</span>
        </div>
        <div class="poll-type">
            <img src="../images/v2-rating-poll.748b1a7e.svg" alt="Rating poll icon">
            <span>Rating poll</span>
        </div>
        <div class="poll-type">
            <img src="../images/v2-open-text.528bda21.svg" alt="Open text icon">
            <span>Open text</span>
        </div>
        <div class="poll-type">
            <img src="../images/v2-ranking-poll.svg" alt="Ranking poll">
            <span>Ranking poll</span>
        </div>
        <div class="poll-type">
            <img src="../images/v2-survey.79c5bdf7.svg" alt="Survey icon">
            <span>Survey</span>
        </div>
    </section>

    <section class="info-section">

        <h1>총 가입자 수</h1>
        <iframe src=http://professortoofast.store:3000/d-solo/bebjlq5axmigwc/admin?orgId=1&refresh=5m&timezone=browser&panelId=1&__feature.dashboardSceneSolo"
                width="350" height="300" frameborder="0"></iframe>
    </section>

    <section class="info-section">

        <h1>총 시험 수</h1>
        <iframe src=http://professortoofast.store:3000/d-solo/bebjlq5axmigwc/admin?orgId=1&refresh=5m&timezone=browser&panelId=7&__feature.dashboardSceneSolo"
                width="350" height="300" frameborder="0"></iframe>
    </section>
    <br>
</main>

</body>
</html>
