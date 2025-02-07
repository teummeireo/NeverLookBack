<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<style>
    .options-menu {
        display: none;
        position: absolute;
        background: white;
        border: 1px solid #ccc;
        border-radius: 5px;
        box-shadow: 2px 2px 10px rgba(0, 0, 0, 0.2);
        z-index: 1000;
        color: #000000;
    }

    .options-menu ul {
        list-style: none;
        margin: 0;
        padding: 10px;
    }

    .options-menu ul li {
        padding: 8px 12px;
        cursor: pointer;
    }

    .options-menu ul li:hover {
        background: #f0f0f0;
    }
</style>

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
<!-- 옵션 메뉴 -->
<div id="optionsMenu" class="options-menu">
    <ul>
        <li onclick="viewResults()">채점 결과 리스트 보기</li>
        <li onclick="changeStatus()">시험 상태 변경</li>
        <li onclick="editExam()">시험 수정</li>
        <li onclick="deleteExam()">시험 삭제</li>
        <li onclick="viewStatistics()">시험 통계 보기</li>
    </ul>
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
            url: "${pageContext.request.contextPath}/api/exams/categories",
            method: "GET",
            success: function (response) {
                categories = response.data;
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
                    response.data.forEach(function (result) {
                        const card = $(`
                        <div class="dashboard-card">
                            <h3>시험 제목: <br>\${result.title}</h3>
                            <p>시험 코드: \${result.examCode}</p>
                            <p>카테고리: \${result.category}</p>
                            <p>응시자 수: \${result.examineeCount}</p>
                            <p>상태: \${result.activationStatus}</p>
                        </div>
                        `);

                        // jQuery 객체에 클릭 이벤트 바인딩
                        card.on("click", function (event) {
                            showOptionsMenu(event, result);
                        });
                        // 컨테이너에 카드 추가
                        container.append(card);
                    });
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
    function showOptionsMenu(event, result) {
        event.stopPropagation();
        const menu = $('#optionsMenu');

        // 옵션 메뉴 표시
        menu.css({
            display: 'block',
            top: event.pageY + 'px',
            left: event.pageX + 'px'
        });

        // 선택된 시험 코드 저장
        menu.data('examVO', result);
        menu.data('examCode', result.examCode);


        console.log("📌 optionsMenu에 저장된 examCode:", $('#optionsMenu').data('examCode')); // 확인용 로그 추가
    }


    function hideOptionsMenu() {
        $('#optionsMenu').hide();
    }

    $(document).click(function () {
        hideOptionsMenu();
    });

    $('#optionsMenu').click(function (event) {
        event.stopPropagation();
    });

    function viewResults() {
        const examCode = $('#optionsMenu').data('examCode');
        console.log("📌 viewResults - 선택된 시험 코드:", examCode);
        alert(`채점 결과 리스트 보기: ${examCode}`);
    }

    function changeStatus() {
        const examVO = $('#optionsMenu').data('examVO');
        console.log("📌 changeStatus - 선택된 시험 정보:", examVO);
        if (examVO.activationStatus === "on_going") {
            if (confirm("정말 비활성화 하시겠습니까?")) {
                examVO.activationStatus = "closed";
                $.ajax({
                    url: "${pageContext.request.contextPath}/api/exams/init/" + examVO.examId,
                    method: "PUT",
                    contentType: "application/json",
                    data: JSON.stringify(examVO),
                    success: function (response) {
                        console.log("응답 : ", response);
                        location.reload()
                        alert(`변경 완료되었습니다.`);
                    },
                    error: function (xhr, status, error) {
                        console.error("에러 : ", error);
                    }
                });
            }
        } else {
            if (confirm("정말 활성화 하시겠습니까?")) {
                examVO.activationStatus = "on_going";
                $.ajax({
                    url: "${pageContext.request.contextPath}/api/exams/init/" + examVO.examId,
                    method: "PUT",
                    contentType: "application/json",
                    data: JSON.stringify(examVO),
                    success: function (response) {
                        console.log("응답 : ", response);
                        location.reload()
                        alert(`변경 완료되었습니다.`);
                    },
                    error: function (xhr, status, error) {
                        console.error("에러 : ", error);
                    }
                });
            }
        }


    }

    function editExam() {
        const examCode = $('#optionsMenu').data('examCode');
        alert(`시험 수정: ${examCode}`);
    }

    function deleteExam() {
        const examCode = $('#optionsMenu').data('examCode');
        if (confirm("정말 삭제하시겠습니까?")) {
            alert(`시험 삭제: ${examCode}`);
        }
    }

    function viewStatistics() {
        const examVO = $('#optionsMenu').data('examVO');
        location.href = "${pageContext.request.contextPath}/admin/statistic/exams/" + examVO.examId + "?createAt=" + examVO.createdAt;
    }
</script>

</body>
</html>
