<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>시험 결과</title>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <link rel="stylesheet" href="/css/submission_check.css">
</head>
<body>
<div class="main-container">
    <%@ include file="/jsp/sidebar.jsp" %>
        <main class="content">
            <div class="container">
                <div class="header">
                    <div class="search-bar">
                        <input type="text" placeholder="응시자 이름을 검색하세요.">
                        <i class="icon-search"></i>
                    </div>
                    <h1>응시자 결과 확인</h1>
                </div>
                <div class="dropdown-container">
                    <!-- 정렬 기준 선택 -->
                    <div class="dropdown">
                        <select id="sortBy" class="sort-select" onchange="fetchResults()">
                            <option value="" disabled selected hidden>정렬</option>
                            <option value="score">점수순</option>
                            <option value="submittedAt">응시 일시순</option>
                            <option value="examineeId">응시자 이름순</option>
                        </select>
                        <span class="arrow">▼</span>
                    </div>
                </div>
            <table border="1">
                <thead>
                <tr>
                    <th>시험 ID</th>
                    <th>응시자 이름</th>
                    <th>점수</th>
                    <th>응시 날짜</th>
                    <th>검토 상태</th>
                </tr>
                </thead>
                <tbody id="resultTableBody">
                <!-- 여기에 데이터가 동적으로 추가됨요 -->
                </tbody>
            </table>
        </div>
<%--            <div className="pagination">--%>
<%--                <button className="btn">이전</button>--%>
<%--                <span>1</span>--%>
<%--                <button className="btn">다음</button>--%>
<%--            </div>--%>
    </main>
</div>

<script>
    function fetchResults() {
        let examId = document.getElementById("examId").value;
        if (examId) {
            console.log("선택된 시험 ID:", examId);
            // 여기서 Ajax 또는 API 요청을 보낼 수 있음
            // 예: window.location.href = `/exam/results?examId=${examId}`;
        }
    }
</script>
<script>
    $(document).ready(function () {
        fetchResults(); // 페이지가 로드되자마자 데이터 가져오기
    });

    function fetchResults() {
        let sortBy = $("#sortBy").val(); // 선택된 정렬 기준 가져오기

        $.ajax({
            url: "/api/exams/results",
            method: "GET",
            dataType: "json",
            success: function (response) {
                let results = response.data; // CMResDTO
                let tableBody = $("#resultTableBody");
                tableBody.empty(); // 기존 데이터 삭제

                if (results.length === 0) {
                    tableBody.append("<tr><td colspan='5'>데이터가 없습니다.</td></tr>");
                } else {
                    // 선택된 정렬 기준에 따라 배열 정렬
                    if (sortBy === "score") {
                        results.sort((a, b) => b.score - a.score); // 점수 내림차순
                    } else if (sortBy === "submittedAt") {
                        results.sort((a, b) => new Date(b.submittedAt) - new Date(a.submittedAt)); // 날짜 내림차순
                    } else if (sortBy === "examineeId") {
                        results.sort((a, b) => a.examineeId.localeCompare(b.examineeId, "ko")); // 이름 오름차순
                    }

                    // 테이블에 데이터 추가
                    $.each(results, function (index, result) {
                        let reviewStatus = result.isReviewed ? "검토 완료" : "이의제기";
                        let reviewClass = result.isReviewed ? "reviewed" : "appealed";

                        let row = "<tr>" +
                            "<td>" + result.examId + "</td>" +
                            "<td>" + result.examineeId + "</td>" +
                            "<td>" + result.score + "</td>" +
                            "<td>" + result.submittedAt + "</td>" +
                            "<td class='" + reviewClass + "'>" + reviewStatus + "</td>" +
                            "</tr>";
                        tableBody.append(row);
                    });
                }
            },
            error: function (error) {
                console.log("에러 발생", error);
            }
        });
    }
</script>
</body>
</html>