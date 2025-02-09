<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>이전 응시 내역</title>
    <link rel="stylesheet" href="/css/exam_result.css">
    <link rel="stylesheet" href="/css/sidebar.css">

</head>
<body>
<div class="main-container">
    <%@ include file="/jsp/sidebar.jsp" %>

    <main class="content">
        <header class="header">
            <h1>이전 응시 내역</h1>
        </header>
        <div class="divider"></div>

        <!-- ✅ 검색 입력창: id 및 name 추가 -->
        <div class="search-bar">
            <input type="text" id="searchInput" name="searchKeyword" placeholder="검색해보세용">
            <i class="icon-search"></i>
        </div>
        <br>

        <!-- ✅ 정렬 드롭다운 -->
        <div class="sort-dropdown">
            <select id="sortOrder" name="sortOrder" onchange="handleSortChange()">
                <option value="">정렬</option>
                <option value="latest">최신순</option>
                <option value="oldest">오래된 순</option>
            </select>
        </div>

        <!-- ✅ 필터 드롭다운 -->
        <div class="filter-dropdown">
            <select id="filterSelect" name="filterSelect" onchange="handleFilterChange()">
                <option value="">필터</option>
                <option value="option1">진행전</option>
                <option value="option2">진행후</option>
                <option value="option3">검토완료</option>
            </select>
        </div>


        <!-- 🚀 결과를 표시할 컨테이너 -->
        <div id="examResultsContainer"></div>
        <br>
    </main>

        <!-- 🔥 loadExamResults가 실행되는 코드 -->
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

        <script>
            $(document).ready(function () {
                console.log("🚀 페이지 로딩 완료: loadExamResults 실행");
                loadExamResults(); // ✅ 페이지가 로드되면 실행
            });

                function loadExamResults() {
                    let userId = ${sessionScope.userId}; // 세션 적용 시 수정 필요
                    let sortBy = "submittedAt"; // 기본 정렬 기준
                    let order = $("#sortOrder").val() === "latest" ? "desc" : "asc"; // 정렬 순서
                    let isReviewed = getFilterValues(); // 필터 값 가져오기
                    let searchKeyword = $("#searchInput").val().trim(); // 검색어 가져오기

                    $.ajax({
                        url: `/api/exams/results/user/` + userId,
                        type: "GET",
                        data: { sortBy: sortBy, order: order, isReviewed: isReviewed },
                        success: function (response) {
                            if (!response.data || response.data.length === 0) {
                                $("#examResultsContainer").html("<p>응시 내역이 없습니다.</p>");
                                return;
                            }
                            globalExamResults = response.data; // ✅ 전역 변수에 데이터 저장
                            renderExamResults(globalExamResults, ""); // ✅ 데이터 렌더링
                        },
                        error: function (xhr, status, error) {
                            console.error("❌ 데이터 불러오기 실패:", error);
                        }
                    });
                }

            function renderExamResults(examResults, searchKeyword) {
                let resultContainer = $("#examResultsContainer");
                resultContainer.empty(); // 기존 내용 초기화

                if (!examResults || examResults.length === 0) {
                    resultContainer.append("<p>응시 내역이 없습니다.</p>");
                    return;
                }
                resultContainer.css("display", "block");
                let htmlContent = ""; // 🔥 누적할 HTML 변수
                examResults.forEach(function (result, index) {
                    let card = `
                        <div class="dashboard-card">
                            <h3>시험 ID: ` + result.examId + `</h3>
                            <p>응시일: ` + result.submittedAt + `</p>
                            <p>점수: ` + result.score + `점</p>
                            <p>검토 상태: ` + (result.isReviewed ? "검토 완료" : "미검토") + `</p>
                            <p>결과 ID: ` + result.resultId + `</p>
                        </div>`;
                    htmlContent += card;
                });

                console.log("📌 최종 HTML Content:", htmlContent); // ✅ 최종 HTML 확인

                resultContainer.html(htmlContent); // ✅ HTML 추가 실행

                console.log("📌 resultContainer 업데이트 후 HTML:", resultContainer.html()); // ✅ 최종 결과 확인
            }



            function getFilterValues() {
                let selectedFilters = [];
                $("input[name='filter']:checked").each(function () {
                    selectedFilters.push($(this).val() === "option3"); // 검토 완료 여부
                });
                return selectedFilters.length > 0 ? selectedFilters[0] : null;
            }
        </script>

    <script>

        function handleFilterChange() {
            var selectedValue = document.getElementById("filterSelect").value;
            console.log("선택된 필터:", selectedValue);
            // 필터 적용 로직 추가
        }

        function handleSortChange() {
            var selectedSort = document.getElementById("sortOrder").value;
            console.log("선택된 정렬:", selectedSort);
            // 정렬 적용 로직 추가
        }
    </script>
</div>
</body>
</html>
