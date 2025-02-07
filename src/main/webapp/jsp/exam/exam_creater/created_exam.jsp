<%--        <script>--%>
<%--            $(document).ready(function () {--%>
<%--                console.log("🚀 페이지 로딩 완료: loadExamResults 실행");--%>
<%--                loadExamResults();--%>
<%--            });--%>


<%--            function loadExamResults() {--%>
<%--                let userId = 1; // 세션 적용 시 수정 필요--%>
<%--                let sortBy = "category"; // 기본 정렬 기준--%>
<%--                let order = $("#sortOrder").val() === "latest" ? "desc" : "asc"; // 정렬 순서--%>
<%--                let isReviewed = getFilterValues(); // 필터 값 가져오기--%>
<%--                let searchKeyword = $("#searchInput").val().trim(); // 검색어 가져오기--%>

<%--                $.ajax({--%>
<%--                    url: '${pageContext.request.contextPath}/api/exams' + userId,--%>
<%--                    type: 'GET',--%>
<%--                    dataType: 'json',--%>
<%--                    data: { sortBy: sortBy, order: order, category: category },--%>
<%--                    success: function (response) {--%>
<%--                        if (!response.data || response.data.length === 0) {--%>
<%--                            $("#examResultsContainer").html("<p>응시 내역이 없습니다.</p>");--%>
<%--                            return;--%>
<%--                        }--%>
<%--                        globalExamResults = response.data; // ✅ 전역 변수에 데이터 저장--%>
<%--                        renderExamResults(globalExamResults, ""); // ✅ 데이터 렌더링--%>
<%--                    },--%>
<%--                    error: function (xhr, status, error) {--%>
<%--                        console.error("❌ 데이터 불러오기 실패:", error);--%>
<%--                    }--%>
<%--                });--%>
<%--            }--%>

<%--            function renderExamResults(examResults, searchKeyword) {--%>
<%--                let resultContainer = $("#examResultsContainer");--%>
<%--                resultContainer.empty(); // 기존 내용 초기화--%>

<%--                if (!examResults || examResults.length === 0) {--%>
<%--                    resultContainer.append("<p>응시 내역이 없습니다.</p>");--%>
<%--                    return;--%>
<%--                }--%>
<%--                resultContainer.css("display", "block");--%>
<%--                let htmlContent = ""; // 🔥 누적할 HTML 변수--%>
<%--                examResults.forEach(function (result, index) {--%>
<%--                    let card = `--%>
<%--                        <div class="dashboard-card">--%>
<%--                            <h3>시험 ID: ` + result.title + `</h3>--%>
<%--                            <p>examcode: ` + result.examCode + `</p>--%>
<%--                            <p>카테고리: ` + result.category + `점</p>--%>
<%--                            <p>응시한 사람: ` + result.examineeCount + `</p>--%>
<%--                            <p>상태 : ` + result.activationStatus + `</p>--%>
<%--                        </div>`;--%>
<%--                    htmlContent += card;--%>
<%--                });--%>
<%--                console.log("📌 최종 HTML Content:", htmlContent); // ✅ 최종 HTML 확인--%>

<%--                resultContainer.html(htmlContent); // ✅ HTML 추가 실행--%>

<%--                console.log("📌 resultContainer 업데이트 후 HTML:", resultContainer.html()); // ✅ 최종 결과 확인--%>
<%--            }--%>

<%--            function getFilterValues() {--%>
<%--                let selectedFilters = [];--%>
<%--                $("input[name='filter']:checked").each(function () {--%>
<%--                    selectedFilters.push($(this).val() === "option3"); // 검토 완료 여부--%>
<%--                });--%>
<%--                return selectedFilters.length > 0 ? selectedFilters[0] : null;--%>
<%--            }--%>


<%--        </script>--%>

<%--        <script>--%>

<%--            function handleFilterChange() {--%>
<%--                var selectedValue = document.getElementById("filterSelect").value;--%>
<%--                console.log("선택된 필터:", selectedValue);--%>
<%--                // 필터 적용 로직 추가--%>
<%--            }--%>

<%--            function handleSortChange() {--%>
<%--                var selectedSort = document.getElementById("sortOrder").value;--%>
<%--                console.log("선택된 정렬:", selectedSort);--%>
<%--                // 정렬 적용 로직 추가--%>
<%--            }--%>
<%--        </script>--%>
<%--</body>--%>
<%--</html>--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/sidebar.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/created_exam.css">
    <title>내가 만든 시험들</title>
</head>
<body>
<div class="main-container">
    <%@ include file="/jsp/sidebar.jsp" %>
    <main class="content">
        <header class="header">
            <h1>내가 만든 시험들</h1>
        </header>
        <div class="divider"></div>

        <div class="sort-dropdown">
            <select id="sortOrder" name="sortOrder" onchange="loadExamResults()">
                <option value="">정렬</option>
                <option value="title">제목 순</option>
                <option value="createdDate">생성일 순</option>
                <option value="participantCount">응시자 수 순</option>
                <option value="category">카테고리 순</option>
            </select>
        </div>

        <!-- 카드 목록 -->
        <div id="examResultsContainer" class="dashboard-grid"></div>
    </main>
</div>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
    <%--const userId = ${sessionScope.SESS_NICKNAME};--%>
    const userId = ${sessionScope.userId};

    $(document).ready(function () {
        loadCategories(); // 카테고리 목록 로드
        loadExamResults(); // 페이지 로드 시 시험 목록 로드
    });

    function loadCategories() {
        $.ajax({
            url: "${pageContext.request.contextPath}/api/categories",
            method: "GET",
            success: function (categories) {
                console.log("📌 불러온 카테고리 목록:", categories); // 응답 데이터 확인
                const filterSelect = $("#filterSelect");
                filterSelect.empty(); // 기존 옵션 초기화
                filterSelect.append('<option value="">카테고리</option>'); // 기본 옵션 추가

                if (categories && categories.length > 0) {
                    categories.forEach(function (category) {
                        filterSelect.append(`<option value="${category}">${category}</option>`);
                    });
                } else {
                    console.warn("⚠ 카테고리 목록이 비어 있습니다.");
                }
            },
            error: function (xhr, status, error) {
                console.error("❌ 카테고리 로드 오류:", error);
            }
        });
    }

    function loadExamResults() {
        const sortBy = $('#sortOrder').val() || 'createdAt';
        const category = $('#filterSelect').val() || '';
        const order = $('#sortOrder').val() === 'latest' ? 'desc' : 'asc';

        $.ajax({
            url: `${pageContext.request.contextPath}/api/exams/` + userId,
            method: 'GET',
            data: {
                sortBy: sortBy,
                order: order,
                category: category
            },
            success: function (response) {
                const container = $('#examResultsContainer');
                container.empty();

                if (response.data && response.data.length > 0) {
                    let htmlContent = '';
                    response.data.forEach(function (result) {
                        const card = `
                            <div class="dashboard-card">
                                <h3>시험 제목: <br>` + result.title + `</h3>
                                <p>시험 코드: ` + result.examCode + `</p>
                                <p>카테고리: ` + result.category + `</p>
                                <p>응시자 수: ` + result.examineeCount + `</p>
                                <p>상태: ` + result.activationStatus + `</p>
                            </div>`;
                        htmlContent += card;
                    });
                    container.html(htmlContent);
                } else {
                    container.html('<p>결과가 없습니다.</p>');
                }
            },
            error: function (xhr, status, error) {
                console.error('❌ 에러:', status, error);
                alert('시험 데이터를 불러오는 중 오류가 발생했습니다.');
            }
        });
    }
</script>

</body>
</html>
