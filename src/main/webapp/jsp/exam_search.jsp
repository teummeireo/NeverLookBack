<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>NeverLookBack</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/exam_search.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/sidebar.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<%-- 현재 로그인한 사용자 ID를 세션에서 가져옴 --%>
    <c:set var="currentUserId" value="${sessionScope.userId}" />
    <script>
      var CURRENT_USER_ID = "${currentUserId}";
    </script>
</head>
<body>
<div class="main-container">
    <%@ include file="sidebar.jsp" %>

    <main class="content">
        <header class="header">
            <div class="search-bar-container">
                <div class="search-bar">
                    <img src="${pageContext.request.contextPath}/images/nlblogo.png" alt="Logo" class="search-logo">
                    <input type="text" id="search-input" autocomplete="off">
                    <button id="search-btn">🔍</button>
                    <ul id="autocomplete-results" class="autocomplete-list hidden"></ul>
                </div>

                <!-- 최근 검색어 영역 -->
                <div id="recent-searches-container" class="hidden">
                    <div class="recent-header">
                        <span>최근 검색어</span>
                        <button id="clear-all-btn">전체삭제</button>
                    </div>
                    <ul id="recent-searches"></ul>
                    <button id="close-recent-searches">닫기</button>
                </div>
            </div>

            <%@ include file="recent_search.jsp" %> <!-- 최근 검색어 기능 포함 -->
            <h1>Never Look Back</h1>
        </header>

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
                <h3>시험 목록</h3>
                <ul id="exam-list">
                    <li>불러오는 중...</li>
                </ul>
            </div>
        </section>

        <section id="result-dashboard" class="dashboard-grid">
            <%@ include file="search_filter.jsp" %>

            <table class="result-table">
                <thead>
                <tr>
                    <th>시험명</th>
                    <th>시험코드</th>
                    <th>카테고리</th>
                    <th>생성자</th>
                    <th>생성일자</th>
                    <th>상태</th>
                    <th>시험시간</th>
                    <th><i class="fas fa-lock"></i></th>
                </tr>
                </thead>
                <tbody id="result-rows"></tbody>
            </table>
        </section>
    </main>
</div>

<script>
  $(document).ready(function () {
    let tableBody = "";

    function executeSearch() {
      let query = $('#search-input').val().trim();
      if (query.length === 0) {
        $('#default-dashboard').show();
        $('#result-dashboard').hide();
        return;
      }

      $.ajax({
        url: '/api/exams/search',
        type: 'GET',
        data: { name: query },
        dataType: 'json',
        success: function (response) {
          if (!response || !response.data || response.data.length === 0) {
            tableBody = "<tr><td colspan='8' style='text-align: center; font-weight: bold; padding: 20px;'>검색된 데이터가 없습니다.</td></tr>";
          } else {
            tableBody = "";
            response.data.forEach(function (exam) {
              let title = exam.title ?? "N/A";
              let category = exam.category ?? "N/A";
              let nickname = exam.nickname ?? "N/A";
              let examCode = exam.examCode ?? "N/A";
              let createdAt = exam.createdAt ? formatDate(exam.createdAt) : "N/A";
              let status = getStatusText(exam.activationStatus);
              let examTime = exam.examTime != null ? exam.examTime + "분" : "N/A";
              let entryIcon = getEntryIcon(exam.entreeCode);
              let examId = exam.examId ?? "N/A";

              tableBody += "<tr data-exam-id='" + examId + "'>" +
                  "<td>" + title + "</td>" +
                  "<td>" + examCode + "</td>" +
                  "<td>" + category + "</td>" +
                  "<td>" + nickname + "</td>" +
                  "<td>" + createdAt + "</td>" +
                  "<td>" + status + "</td>" +
                  "<td>" + examTime + "</td>" +
                  "<td>" + entryIcon + "</td>" +
                  "</tr>";
            });
          }

          $('#result-rows').html(tableBody);
          $('#default-dashboard').toggle(tableBody === "");
          $('#result-dashboard').toggle(tableBody !== "");
          localStorage.setItem('searchName', query);
        },
        complete: function () {
          $.ajax({
            url: '/api/search-history/save',
            type: 'POST',
            data: { userId: CURRENT_USER_ID, searchTerm: query },
          });
        }
      });
    }

    // 검색창 돋보기 아이콘 클릭 시 검색
    $('#search-btn').on('click', executeSearch);

    // enter키 입력 시 검색
    $('#search-input').on('keypress', function (event) {
      if (event.which === 13) {
        event.preventDefault();
        executeSearch();
      }
    });
  });

  // 전체 중 10개 시험 조회
  function loadExamList() {
    $.ajax({
      url: "/api/exams/all",
      type: "GET",
      dataType: "json",
      success: function (response) {
        let listItems = "";
        if (response.length === 0) {
          listItems = "<li class='no-data'>시험 목록이 없습니다.</li>";
        } else {
          let count = 0;  // 출력 개수 제한을 위한 변수
          response.forEach(function (exam) {
            if (count >= 10) return;  // 10개까지만 출력

            listItems += "<li>" +
                "<b>" + (exam.title ?? "N/A") + "</b> (" +
                (exam.examCode ?? "N/A") + ") - " +
                getStatusText(exam.activationStatus) + " / " +
                (exam.examTime ? exam.examTime + "분" : "N/A") +
                "</li>";

            count++; // 개수 증가
          });
        }
        $("#exam-list").html(listItems);
      },
      error: function () {
        $("#exam-list").html("<li class='no-data'>시험 목록을 불러오지 못했습니다.</li>");
      }
    });
  }


  function formatDate(dateString) {
    return new Date(dateString).toISOString().slice(0, 19).replace("T", " ");
  }

  function getStatusText(status) {
    if (status === "not_started") {
      return "시험 전";
    } else if (status === "on_going") {
      return "시험 중";
    } else if (status === "closed") {
      return "시험 종료";
    } else {
      return "알 수 없음";
    }
  }

  function getEntryIcon(entreeCode) {
    if (entreeCode === null || entreeCode === "" || entreeCode === "<null>") {
      return '<i class="fas fa-unlock" title="공개방" data-entree-code="' + entreeCode + '"></i>'; // 공개방
    } else {
      return '<i class="fas fa-lock" title="비밀방" data-entree-code="' + entreeCode + '"></i>'; // 비밀방
    }
  }


  // 전체 중 10개 시험 조회
  loadExamList();
</script>

</body>
</html>