<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Main Dashboard</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/sidebar.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/search_filter.css">

</head>
<body>
<div class="main-container">
    <%@ include file="sidebar.jsp" %>

    <main class="content">
        <header class="header">
            <div class="search-bar">
                <input type="text" placeholder="Search (Ctrl+/)">
            </div>
            <h1>Dashboard Analytics</h1>
        </header>

        <!-- 기본 메인 폼 -->
        <section id="default-dashboard" class="dashboard-grid">
            <div class="dashboard-card">
                <h3>Statistics</h3>
                <p>Some detailed statistics...</p>
            </div>
            <div class="dashboard-card">
                <h3>NLB 방문자 그래프</h3>
                <p>일일 방문자 수 그래프</p>
            </div>
            <div class="dashboard-card">
                <h3>실시간 시험 목록</h3>
                <ul>
                    <li>시험 응시자 내림차순 1</li>
                    <li>시험 응시자 내림차순 2</li>
                    <li>시험 응시자 내림차순 3</li>
                </ul>
            </div>
            <div class="dashboard-card">
                <h3>생성된 카테고리 목록</h3>
                <ul>
                    <li>JAVA 126건 생성</li>
                    <li>C 98건 생성</li>
                    <li>C++ 67건 생성</li>
                </ul>
            </div>
            <div class="dashboard-card">
                <h3>Project List</h3>
                <ul>
                    <li>Project 1 - In Progress</li>
                    <li>Project 2 - Completed</li>
                    <li>Project 3 - Pending</li>
                </ul>
            </div>
        </section>

        <!-- 검색 결과 및 필터링 UI 포함 -->
        <section id="result-dashboard" class="dashboard-grid">
            <%@ include file="search_filter.jsp" %>  <!-- 필터링 UI 포함 -->

            <table class="result-table">
                <thead>
                <tr>
                    <th>시험명</th>
                    <th>카테고리</th>
                    <th>생성자</th>
                    <th>생성일자</th>
                    <th>상태</th>
                    <th>시험시간</th>
                </tr>
                </thead>
                <tbody id="result-rows">
                <!-- 검색 결과 데이터가 여기에 추가됨 -->
                </tbody>
            </table>
        </section>

    </main>
</div>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
  $(document).ready(function () {
    let timer;

    $('.search-bar input').on('input', function () {
      clearTimeout(timer);
      let query = $(this).val().trim();

      if (query.length === 0) {
        $('#default-dashboard').show();
        $('#result-dashboard').hide();
        return;
      }

      timer = setTimeout(function () {
        $.ajax({
          url: '/api/exams/search',
          type: 'GET',
          data: {name: query},
          dataType: 'json',
          success: function (response) {
            if (!response || !response.data || response.data.length === 0) {
              tableBody += `<tr>
                                <td colspan="6" style="text-align:center;">검색된 데이터가 없습니다.</td>
                            </tr>`;

              $('#default-dashboard').show();
              $('#result-dashboard').hide();
              return;
            }

            $('#default-dashboard').hide();
            $('#result-dashboard').show();
            let tableBody = "";

            response.data.forEach(function (exam) {
              let title = exam.title ?? "N/A";
              let category = exam.category ?? "N/A";
              let creator = exam.createrId ?? "N/A";
              let createdAt = exam.createdAt ? formatDate(exam.createdAt) : "N/A";
              let status = getStatusText(exam.activationStatus);
              let examTime = exam.examTime ? `${exam.examTime}분` : "0분";

              tableBody += "<tr>" +
                  "<td>" + title + "</td>" +
                  "<td>" + category + "</td>" +
                  "<td>" + creator + "</td>" +
                  "<td>" + createdAt + "</td>" +
                  "<td>" + status + "</td>" +
                  "<td>" + examTime + "</td>" +
                  "</tr>";
            });

            $('#result-rows').html(tableBody);
          },
          error: function () {
            console.error('검색 요청 실패');
          }
        });
      }, 500);
    });
  });

  // ISO 8601 → 일반 날짜 변환 , T를 공백으로 제거
  function formatDate(dateString) {
    let date = new Date(dateString);
    return date.toISOString().slice(0, 19).replace("T", " ");
  }

  // 영어 상태값을 한글로 변환하는 함수
  function getStatusText(status) {
    switch (status) {
      case "not_started":
        return "시험 전";
      case "on_going":
        return "시험 중";
      case "closed":
        return "시험 종료";
      default:
        return "알 수 없음"; // 예외 처리
    }
  }


</script>


</body>
</html>

