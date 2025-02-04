<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>

<!-- 필터 UI -->
<div class="filter-container">
  <div class="filter-options">
    <select id="filter-category" class="filter-select">
      <option value="">카테고리 선택</option>
      <option value="Java">Java</option>
      <option value="Python">Python</option>
      <option value="C">C</option>
      <option value="C++">C++</option>
      <option value="C#">C#</option>
    </select>
    <input type="number" id="filter-creator" class="filter-input" placeholder="생성자 ID입력" min="0">
    <input type="text" id="filter-createdAt" class="form-control" placeholder="날짜 선택 (yyyy-MM-dd)">
    <select id="filter-status" class="filter-select">
      <option value="">상태 선택</option>
      <option value="not_started">시험 전</option>
      <option value="on_going">시험 중</option>
      <option value="closed">시험 종료</option>
    </select>
    <select id="filter-examTime" class="filter-select">
      <option value="">시험시간 선택</option>
      <option value="30">30분 이하</option>
      <option value="60">60분 이하</option>
      <option value="90">90분 이하</option>
    </select>
  </div>
</div>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
  $(document).ready(function () {
    let debounceTimer; // 디바운스 타이머 변수
    let currentSearchName = localStorage.getItem('searchName'); // 현재 검색어 저장 변수

    // 필터 적용 함수
    function applyFilters() {
      let category = $('#filter-category').val();
      let creator = $('#filter-creator').val().trim();
      let createdAt = $('#filter-createdAt').val().trim();
      let activationStatus = $('#filter-status').val();
      let examTime = $('#filter-examTime').val();

      let filterParams = {
        name: currentSearchName || null, // 검색어 유지
        category: category || null,
        creator: creator || null,
        createdAt: createdAt || null,
        activationStatus: activationStatus || null,
        examTime: examTime || null
      };

      // 필터 값이 모두 null이고 name 값만 존재하는 경우, url을 `/api/exams/search`로 변경
      let isFilterEmpty = !category && !creator && !createdAt && !activationStatus && !examTime;
      let apiUrl = isFilterEmpty && currentSearchName ? '/api/exams/search' : '/api/exams/filter';

      console.log("필터링 요청:", filterParams);

      // Ajax 요청
      $.ajax({
        url: apiUrl,
        type: 'GET',
        data: filterParams,
        dataType: 'json',
        success: function (response) {
          if (!response || !response.data || response.data.length === 0) {
            tableBody = "<tr>" +
                    "<td colspan='7' style='text-align: center; font-weight: bold; padding: 20px;'>검색된 데이터가 없습니다.</td>" +
                    "</tr>";

            $('#result-rows').html(tableBody);

            return;
          }

          renderTable(response.data);
        },
        error: function () {
          console.error('필터링 요청 실패');
        }
      });
    }

    // 결과 테이블 렌더링 함수
    function renderTable(data) {
      let tableBody = "";

      data.forEach(function (exam) {
        let title = exam.title ?? "N/A";
        let category = exam.category ?? "N/A";
        let creator = exam.createrId ?? "N/A";
        let examCode = exam.examCode ?? "N/A";
        let createdAt = exam.createdAt ? formatDate(exam.createdAt) : "N/A";
        let status = getStatusText(exam.activationStatus);
        let examTime = exam.examTime ?? `${exam.examTime}분`;

        tableBody +=
                "<tr>" +
                "<td>" + title + "</td>" +
                "<td>" + examCode + "</td>" +
                "<td>" + category + "</td>" +
                "<td>" + creator + "</td>" +
                "<td>" + createdAt + "</td>" +
                "<td>" + status + "</td>" +
                "<td>" + examTime + "</td>" +
                "</tr>";
      });

      $('#result-rows').html(tableBody);
    }

    // 날짜 포맷 함수
    function formatDate(dateString) {
      let date = new Date(dateString);
      return date.toISOString().slice(0, 10); // yyyy-MM-dd 형식 반환
    }

    // 상태 텍스트 변환 함수
    function getStatusText(status) {
      switch (status) {
        case "not_started":
          return "시험 전";
        case "on_going":
          return "시험 중";
        case "closed":
          return "시험 종료";
        default:
          return "알 수 없음";
      }
    }

    // 디바운스 적용된 입력 이벤트 (creator 입력 시 실시간 필터링)
    $('#filter-creator, #filter-createdAt').on('input', function () {
      clearTimeout(debounceTimer); // 이전 타이머 초기화
      debounceTimer = setTimeout(function () {
        applyFilters(); // 입력 후 150ms 뒤 필터 실행
      }, 150);
    });

    // 다른 필터 변경 시 즉시 필터 실행
    $('#filter-category, #filter-status, #filter-examTime').on('change', function () {
      applyFilters();
    });
  });



</script>