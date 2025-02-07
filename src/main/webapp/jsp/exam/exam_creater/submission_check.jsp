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
                    <input type="text" placeholder="ExamId를 통해 응시자 결과 확인을 해보세요.">
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
    </main>
</div>

<script>
    function fetchResults() {
        let examId = document.getElementById("examId").value;
        if (examId) {
            console.log("선택된 시험 ID:", examId);
        }
    }
</script>
<script>
    $(document).ready(function () {
        console.log("페이지에 데이터 갖고오기");
        fetchResults(); // 페이지가 로드되자마자 데이터 가져오기
    });

    function fetchResults() {
        let sortBy = $("#sortBy").val();

        $.ajax({
            url: "/api/exams/results/" + 1,
            method: "GET",
            dataType: "json",
            beforeSend: function () {
                console.log("시험결과 데이터 갖고오기");
            },
            success: function (response) {
                console.log("API Response:", response);

                let results = response.data; // CMResDTO
                let tableBody = $("#resultTableBody");
                tableBody.empty(); // 기존 데이터 삭제

                if (!results || results.length === 0) {
                    console.warn("데이터 없다");
                    tableBody.append("<tr><td colspan='5'>데이터가 없습니다.</td></tr>");
                    return;
                }

                // 선택된 정렬 기준에 따라 배열 정렬
                if (sortBy === "score") {
                    results.sort((a, b) => b.score - a.score); // 점수 내림차순
                } else if (sortBy === "submittedAt") {
                    results.sort((a, b) => new Date(b.submittedAt) - new Date(a.submittedAt)); // 날짜 내림차순
                } else if (sortBy === "examineeId") {
                    results.sort((a, b) => a.examineeId.localeCompare(b.examineeId, "ko")); // 이름 오름차순
                }

                console.log("Sorted Results:", results);

                // 테이블에 데이터 추가
                $.each(results, function (index, result) {
                    let reviewStatus = result.reviewed ? "검토 완료" : "검토 전";
                    let reviewClass = result.reviewed ? "reviewed" : "appealed";

                    let row = "<tr>" +
                        "<td>" + result.examId + "</td>" +
                        "<td>" + result.examineeId + "</td>" +
                        "<td>" + result.score + "</td>" +
                        "<td>" + result.submittedAt + "</td>" +
                        "<td class='" + reviewClass + "'>" + reviewStatus + "</td>" +
                        "</tr>";

                    console.log("리스트 확인", row);
                    tableBody.append(row);
                });
            },
            error: function (error) {
                console.error("펑션 에러", error);
            }
        });
    }
</script>
</body>
</html>