<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Main Dashboard</title>
    <link rel="stylesheet" href="/css/exam_result.css">
</head>
<body>
<div class="main-container">
    <%@ include file="/jsp/sidebar.jsp" %>

    <main class="content">
        <header class="header">
            <h1>이전 응시 내역</h1>
        </header>
        <div class="divider"></div>
        <div class="search-bar">
            <input type="text" placeholder="검색해보세용">
            <i class="icon-search"></i>
        </div>
        <div class="sort-dropdown">
            <select id="sortOrder" name="sortOrder" onchange="handleSortChange()">
                <option value="latest">최신순</option>
                <option value="oldest">오래된 순</option>
            </select>
        </div>
        <div class="filter-container">
            <button class="filter-button" onclick="toggleFilterMenu()">필터 ▼</button>
            <div class="filter-menu" id="filterMenu">
                <label><input type="checkbox" name="filter" value="option1">진행전</label>
                <label><input type="checkbox" name="filter" value="option2">진행후</label>
                <label><input type="checkbox" name="filter" value="option3">검토완료</label>
            </div>
        </div>

        <!-- 🚀 결과를 표시할 컨테이너 -->
        <div id="examResultsContainer"></div>
<br>
    </main>


    </main>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script>
        $(document).ready(function () {
            loadExamResults(); // 페이지 로드 시 실행

            // 정렬 드롭다운 변경 시 호출
            $("#sortOrder").change(function () {
                loadExamResults();
            });

            // 필터 체크박스 변경 시 호출
            $("input[name='filter']").change(function () {
                loadExamResults();
            });

            // 검색 기능 추가
            $(".search-bar input").on("input", function () {
                loadExamResults();
            });
        });
        function loadExamResults() {
            let userId = 1; // 세션 적용 시 수정 필요
            let sortBy = "submittedAt"; // 기본 정렬 기준
            let order = $("#sortOrder").val() === "latest" ? "desc" : "asc"; // 정렬 순서
            let isReviewed = getFilterValues(); // 필터 값 가져오기
            let searchKeyword = $(".search-bar input").val().trim(); // 검색어

            $.ajax({
                url: `/api/exams/results/user/1`,
                type: "GET",
                data: { sortBy: sortBy, order: order, isReviewed: isReviewed },
                success: function (response) {
                    console.log("데이터 로드 성공:", response.data);

                    if (!response.data || response.data.length === 0) {
                        console.warn("데이터가 없습니다.");
                        $("#examResultsContainer").html("<p>응시 내역이 없습니다.</p>");
                        return;
                    }

                    renderExamResults(response.data, searchKeyword);
                },
                error: function (xhr, status, error) {
                    console.error("데이터 불러오기 실패:", error);
                }
            });
        }

        function renderExamResults(examResults, searchKeyword) {
            let resultContainer = $("#examResultsContainer");
            resultContainer.empty(); // 기존 내용 초기화

            if (examResults.length === 0) {
                resultContainer.append("<p>응시 내역이 없습니다.</p>");
                return;
            }

            examResults.forEach(function (result) {
                // 검색어 필터 적용 (examTitle 기준)
                if (searchKeyword && !result.examTitle.includes(searchKeyword)) return;

                let card = `
            <div class="dashboard-card">
                <h3>시험 제목: ${result.examTitle}</h3>
                <p>응시일: ${result.submittedAt}</p>
                <p>점수: ${result.score}점</p>
                <p>검토 상태: ${result.isReviewed ? "검토 완료" : "미검토"}</p>
                <p>시험 ID: ${result.examId}</p>
                <p>결과 ID: ${result.resultId}</p>
            </div>`;
                resultContainer.append(card);
            });
        }



        function getFilterValues() {
            let selectedFilters = [];
            $("input[name='filter']:checked").each(function () {
                selectedFilters.push($(this).val() === "option3"); // 검토 완료 여부
            });
            return selectedFilters.length > 0 ? selectedFilters[0] : null;
        }
    </script>

<%--    <script>--%>
<%--        function handleSortChange() {--%>
<%--            const sortOrder = document.getElementById('sortOrder').value;--%>
<%--            if (sortOrder === 'latest') {--%>
<%--                // 최신순 정렬 로직 추가--%>
<%--            } else if (sortOrder === 'oldest') {--%>
<%--                // 오래된 순 정렬 로직 추가--%>

<%--            }--%>
<%--        }--%>

<%--        function toggleFilterMenu() {--%>
<%--            const filterMenu = document.getElementById('filterMenu');--%>
<%--            filterMenu.style.display = filterMenu.style.display === 'block' ? 'none' : 'block';--%>
<%--        }--%>

<%--    </script>--%>
</div>
</body>
</html>