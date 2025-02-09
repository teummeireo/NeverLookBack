<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>NeverLookBack 검색 tool</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/exam_search.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/sidebar.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>


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

                <!-- 자동완성 영역 -->
                <div id="autocomplete-container" class="hidden">
                    <div class="autocomplete-header">
                        <span>자동완성</span>
                    </div>
                    <ul id="autocomplete-searches"></ul>
                    <button id="close-autocomplete-searches">닫기</button>
                </div>
            </div>

            <%@ include file="recent_search.jsp" %> <!-- 최근 검색어 기능 포함 -->

            <h3>
                <i id="nickname-icon" class="fas fa-user-circle"></i>
                <span id="nickname">${nickname}님, 오늘도 만점 목표!</span>
            </h3>

        </header>
        <section id="default-dashboard" class="dashboard-grid">
            <div class="dashboard-card card-live-exams">
                <h3><i class="fas fa-clock icon-heading"></i> 실시간 시험 목록</h3>
                <ul id="title-count-list">
                    <li>불러오는 중...</li>
                </ul>
            </div>

            <div class="dashboard-card card-categories">
                <h3><i class="fas fa-list icon-heading"></i> 생성된 카테고리 목록</h3>
                <ul id="category-count-list">
                    <li>불러오는 중...</li>
                </ul>
            </div>

            <div class="dashboard-card card-top10">
                <h3><i class="fas fa-fire-alt icon-heading"></i> 인기 시험 TOP 10</h3>
                <ul id="popular-top10-list">
                    <li>불러오는 중...</li>
                </ul>
            </div>

            <div class="dashboard-card card-daily-visitors">
                <h3><i class="fas fa-chart-bar icon-heading"></i> NLB 일일 방문자</h3>
                <canvas id="daily-visitor-chart" width="300" height="200"></canvas>
            </div>

            <div class="dashboard-card card-weekly-visitors">
                <h3><i class="fas fa-chart-line icon-heading"></i> NLB 주간 방문자</h3>
                <canvas id="weekly-visitor-chart" width="300" height="200"></canvas>
            </div>

            <div class="dashboard-card card-recent-score flip-card">
                <div class="flip-card-inner">
                    <!-- 앞면 -->
                    <div class="flip-card-front">
                        <!-- 문구 -->
                        <i class="fas fa-user-graduate icon-heading"></i><p>내가 봤던 시험 점수 공개!</p>
                    </div>

                    <!-- 뒷면 -->
                    <div class="flip-card-back">
                        <h3><i class="fas fa-user-graduate icon-heading"></i> 내 최근 성적</h3>
                        <ul id="recent-score-list">
                            <li>불러오는 중...</li>
                        </ul>
                    </div>
                </div>
            </div>

            <div class="dashboard-card card-tip">
                <h3><i class="fas fa-lightbulb icon-heading"></i> 오늘의 TIP</h3>
                <ul>
                    <li>시험 보기 전, 샘플 문제를 꼭 검토하세요.</li>
                    <li>기록은 습관! 오답노트를 만들어보세요.</li>
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
    $('#result-dashboard').hide();
    let tableBody = "";

    loadCategoryCount();
    loadTitleCount();
    loadDailyVisitors();
    loadWeeklyVisitors();
    loadPopularTop10();
    loadRecentScores();

    // 초기 로드 시 사용자 정보 가져오기 호출
    loadUserInfo();

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

    // 생성된 시험 목록 리스트 호출 함수
    function loadCategoryCount() {
      $.ajax({
        url: "/api/exams/categoriesCount",
        type: "GET",
        dataType: "json",
        success: function (response) {
          let listHtml = "";
          if (!response || response.length === 0) {
            listHtml = "<li>카테고리가 없습니다.</li>";
          } else {
            // 카테고리별 건수를 순회하며 <li> 추가
            response.forEach(function (item) {
              // 예: JAVA 카테고리가 12건이면 => "JAVA 12건 생성"
              listHtml += "<li>" + item.category + " " + item.examCount + "건 생성</li>";
            });
          }
          $("#category-count-list").html(listHtml);
        },
        error: function () {
          $("#category-count-list").html("<li>카테고리 정보를 불러오지 못했습니다.</li>");
        }
      });
    }

    // 실시간 생성된 시험 목록
    function loadTitleCount() {
      $.ajax({
        url: "/api/exams/all",
        type: "GET",
        dataType: "json",
        success: function (response) {
          let listHtml = "";
          if (!response || response.length === 0) {
            listHtml = "<li>생성된 시험이 존재하지 않습니다.</li>";
          } else {
            // 생성된 시험 건수를 순회하며 <li> 추가
            response.forEach(function (item) {
              // 예: JAVA 카테고리가 12건이면 => "JAVA 12건 생성"
              listHtml += "<li>" + item.title + "</li>";
            });
          }
          $("#title-count-list").html(listHtml);
        },
        error: function () {
          $("#title-count-list").html("<li>생성된 시험 정보를 불러오지 못했습니다.</li>");
        }
      });
    }

    // 일간 방문자 수
    function loadDailyVisitors() {
      $.ajax({
        url: "/api/exams/dailyVisitors",
        type: "GET",
        dataType: "json",
        success: function(data) {
          // data = [{ dateKey: '2025-02-05', visitorCount: 3 }, ...]

          // (A) 년도가 2025이고, dayNum <= 7 인 것만 필터
          const filtered = data.filter(item => {
            let rawDate = item.dateKey;        // '2025-02-05'
            let yearStr = rawDate.substring(0, 4);  // "2025"
            let dayNum  = parseInt(rawDate.substring(8, 10), 10);
            return (yearStr === '2025') && (dayNum <= 7);
          });

          // (B) labels / counts
          const labels = filtered.map(item => item.dateKey);
          const counts = filtered.map(item => item.visitorCount);

          const ctx = document.getElementById('daily-visitor-chart').getContext('2d');
          new Chart(ctx, {
            type: 'bar',
            data: {
              labels: labels,
              datasets: [{
                label: '일일 방문자수',
                data: counts,
                backgroundColor: 'rgba(75,192,192,0.6)'
              }]
            },
            options: {
              scales: {
                y: {
                  beginAtZero: true,
                  ticks: {
                    stepSize: 1,          // 정수만
                    callback: function(value) {
                      return value + "명";
                    }
                  }
                },
                x: {
                  ticks: {
                    // '2025-02-05' → "5일"
                    callback: function(value, index) {
                      const rawLabel = labels[index];
                      let dayNum = parseInt(rawLabel.substring(8, 10), 10);
                      return dayNum + "일";
                    }
                  }
                }
              }
            }
          });
        }
      });
    }



    // 주간 방문자 수
    function loadWeeklyVisitors() {
      $.ajax({
        url: "/api/exams/weeklyVisitors",
        type: "GET",
        dataType: "json",
        success: function(data) {
          // 현재 날짜 가져오기
          const today = new Date();
          const currentYear = today.getFullYear(); // 2025
          const currentMonth = today.getMonth() + 1; // 1월 = 0, 그래서 +1 필요
          const currentDay = today.getDate();

          // 현재 월의 첫날
          const firstDayOfMonth = new Date(today.getFullYear(), today.getMonth(), 1);
          // 첫 번째 날의 요일 (0: 일요일, 1: 월요일, ...)
          const firstDayWeekday = firstDayOfMonth.getDay();

          // 현재 날짜까지 몇 번째 주인지 계산
          const currentWeek = Math.ceil((currentDay + firstDayWeekday) / 7);

          // 데이터 필터링: 현재 연도, 현재 월, 그리고 현재 주까지만 표시
          const filtered = data.filter(item => {
            const [year, week] = item.dateKey.split("-").map(Number);
            const weekMonth = Math.ceil((week + firstDayWeekday) / 7);
            return year === currentYear && weekMonth <= currentWeek;
          });

          // 라벨 및 데이터 생성
          const labels = filtered.map(item => {
            const [year, week] = item.dateKey.split("-");
            const weekMonth = Math.ceil((week + firstDayWeekday) / 7);
            return `${currentMonth}월 ${weekMonth}주`;
          });
          const counts = filtered.map(item => item.visitorCount);

          // Chart.js로 그래프 렌더링
          const ctx = document.getElementById("weekly-visitor-chart").getContext("2d");
          new Chart(ctx, {
            type: "line",
            data: {
              labels: labels,
              datasets: [{
                label: "주간 방문자수",
                data: counts,
                borderColor: "rgba(255,99,132,1)",
                fill: false,
              }],
            },
            options: {
              scales: {
                y: {
                  beginAtZero: true,
                  ticks: {
                    stepSize: 1,
                    callback: function (value) {
                      return value + "명";
                    },
                  },
                },
                x: {
                  ticks: {
                    callback: function (value, index) {
                      return labels[index];
                    },
                  },
                },
              },
            },
          });
        },
        error: function () {
          console.error("주간 방문자 데이터를 불러오는 중 오류가 발생했습니다.");
        },
      });
    }





    // 실시간 인기시험 Top10
    function loadPopularTop10() {
      $.ajax({
        url: "/api/exams/popular10", // 컨트롤러의 @GetMapping("/popular10") 경로
        type: "GET",
        dataType: "json",
        success: function(response) {
          let listHtml = "";
          if (!response || response.length === 0) {
            listHtml = "<li>인기 시험이 없습니다.</li>";
          } else {
            // 예: response = [{examId:..., title:..., examineeCount:...}, ...]
            response.forEach(function(exam, index) {
              const rank = index + 1; // 1~10
              const title = exam.title ?? "N/A";
              const count = exam.examineeCount ?? 0;

              // ★ (A) 아이콘으로 랭킹 번호 표시: rank-1, rank-2 ... rank-10
              let rankIcon = "<i class='rank-icon rank-" + rank + "'></i>";

              // ★ (B) HTML 구성
              listHtml += "<li>" + rankIcon
                  + "<span class='exam-title'>" + title + "</span>"
                  + "<span class='exam-count'> (" + count + "명)</span>"
                  + "</li>";
            });
          }
          // ul#popular-top10-list 에 결과 반영
          $("#popular-top10-list").html(listHtml);
        },
        error: function() {
          $("#popular-top10-list").html("<li>인기 시험 정보를 불러오는 중 오류가 발생했습니다.</li>");
        }
      });
    }

    function loadRecentScores() {
      $.ajax({
        url: "/api/exams/recentScores",
        type: "GET",
        data: { userId: CURRENT_USER_ID }, // 세션 등에서 userId
        dataType: "json",
        success: function(response) {
          let html = "";
          if (!response || response.length === 0) {
            html = "<li>최근 성적 데이터가 없습니다.</li>";
          } else {
            response.forEach(function(item) {
              // { examTitle: "..", score: 80, submittedDate: "2025-02-10" }
              html += "<li>"
                  + item.examTitle + " - "
                  + item.score + "점 (" + item.submittedDate + ")"
                  + "</li>";
            });
          }
          $("#recent-score-list").html(html);
        },
        error: function() {
          $("#recent-score-list").html("<li>최근 성적을 불러오는 중 오류가 발생했습니다.</li>");
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


  function formatDate(dateString) {
    return new Date(dateString).toISOString().slice(0, 19).replace("T", " ");
  }

  function getStatusText(status) {
    switch (status) {
      case "not_started": return "시험 전";
      case "on_going": return "시험 중";
      case "closed": return "시험 종료";
      default: return "알 수 없음";
    }
  }

  // 공개/비공개 아이콘을 반환하는 함수
  function getEntryIcon(entreeCode) {
    if (entreeCode === null || entreeCode === "" || entreeCode === "<null>") {
      return '<i class="fas fa-unlock" title="공개방" data-entree-code="' + entreeCode + '"></i>'; // 공개방
    } else {
      return '<i class="fas fa-lock" title="비밀방" data-entree-code="' + entreeCode + '"></i>'; // 비밀방
    }
  }

  // 현재 로그인한 사용자 정보 가져오기
  function loadUserInfo() {
    $.ajax({
      url: '/user/info', // 컨트롤러의 @GetMapping("/user/info") 경로
      type: 'GET',
      dataType: 'json',
      success: function (response) {
        if (response.success) {
          $('#nickname').text(response.data.nickname);

          const sessionExpireTime = response.data.sessionExpireTime; // 세션 만료 시간
          const now = new Date().getTime();
          const remainingTime = sessionExpireTime - now;

          if (remainingTime > 0) {
            startLogoutTimer(remainingTime);
          }
        } else {
          console.error('사용자 정보를 불러오는 데 실패했습니다.');
        }
      },
      error: function () {
        console.error('사용자 정보를 불러오는 중 오류가 발생했습니다.');
      }
    });
  }

  // 세션 만료 타이머 시작 함수
  function startLogoutTimer(duration) {
    let timer = duration / 1000; // 초 단위
    const interval = setInterval(function () {
      const minutes = Math.floor(timer / 60);
      const seconds = Math.floor(timer % 60);
      $('#logout-timer').text(`${minutes}:${seconds < 10 ? '0' + seconds : seconds}`);
      timer--;

      if (timer < 0) {
        clearInterval(interval);
        $('#logout-timer').text("로그아웃 됨");
        alert('세션이 만료되었습니다. 다시 로그인해주세요.');
        window.location.href = '/login'; // 로그인 페이지로 리다이렉트
      }
    }, 1000);
  }


</script>

</body>
</html>