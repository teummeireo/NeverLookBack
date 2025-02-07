<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>

<!-- 필터 UI -->
<div class="filter-container">
  <div class="filter-options">
    <!-- 카테고리 필터 -->
    <select id="filter-category" class="filter-select">
      <option value="" disabled selected hidden>과목</option>
      <option value="Java">Java</option>
      <option value="Python">Python</option>
      <option value="C">C</option>
      <option value="C++">C++</option>
      <option value="C#">C#</option>
      <option value="Programming">Programming</option>
    </select>

    <!-- 생성자 필터 -->
    <input type="number" id="filter-creator" class="filter-input" placeholder="시험 생성자ID 입력" min="0">

    <!-- 날짜 필터 -->
    <input type="text" id="filter-createdAt" class="form-control" placeholder="날짜 필터 (yyyy-MM-dd)">

    <!-- 진행도 필터 -->
    <select id="filter-status" class="filter-select">
      <option value="" disabled selected hidden>진행도</option>
      <option value="not_started">시험 전</option>
      <option value="on_going">시험 중</option>
      <option value="closed">시험 종료</option>
    </select>

    <!-- 시험 종료 시간 필터 -->
    <select id="filter-examTime" class="filter-select">
      <option value="" disabled selected hidden>시험종료</option>
      <option value="30">30분 이하</option>
      <option value="60">60분 이하</option>
      <option value="90">90분 이하</option>
    </select>

    <!-- 공개 설정 필터 -->
    <select id="filter-roomType" class="filter-select">
      <option value="" disabled selected hidden>공개설정</option>
      <option value="open">공개</option>
      <option value="close">비공개</option>
    </select>

    <!-- 필터 초기화 버튼을 아이콘으로 변경 -->
    <i id="reset-filters" class="fas fa-sync-alt reset-icon" title="필터 초기화"></i>
  </div>
</div>



<script>
  $(document).ready(function () {
    let debounceTimer; // 디바운스 타이머 변수
    let currentSearchName = ""; // 현재 검색어 저장 변수

    // 필터 적용 함수
    function applyFilters() {
      let examId = localStorage.getItem("selectedExamId"); // 저장된 examId 가져오기
      if (!examId) {
        console.warn("선택된 examId가 없습니다. 필터링 요청이 중단됩니다.");
        return;
      }

      let category = $('#filter-category').val();
      let creator = $('#filter-creator').val().trim();
      let createdAt = $('#filter-createdAt').val().trim();
      let activationStatus = $('#filter-status').val();
      let examTime = $('#filter-examTime').val();
      let entreeCode = $('#filter-roomType').val();

      let filterParams = {
        name: localStorage.getItem('searchName') || null, // 검색어 유지
        category: category || null,
        creator: creator || null,
        createdAt: createdAt || null,
        activationStatus: activationStatus || null,
        examTime: examTime || null,
        entreeCode: entreeCode || null,
        examId: examId // 저장된 examId 추가
      };

      // 필터 값이 없고 검색어만 존재하면 검색 API 호출
      let isFilterEmpty = !category && !creator && !createdAt && !activationStatus && !examTime && !entreeCode;
      let apiUrl = isFilterEmpty ? '/api/exams/search' : '/api/exams/filter'; // 필터링 시 검색이 아닌 필터링 API 호출

      console.log("필터링 요청:", filterParams);

      // Ajax 요청
      $.ajax({
        url: apiUrl,
        type: 'GET',
        data: filterParams,
        dataType: 'json',
        success: function (response) {
          if (!response || !response.data || response.data.length === 0) {
            $('#result-rows').html("<tr><td colspan='8' style='text-align: center; font-weight: bold; padding: 20px;'>필터링된 데이터가 없습니다.</td></tr>");
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
        let nickname = exam.nickname ?? "N/A";
        let examCode = exam.examCode ?? "N/A";
        let createdAt = exam.createdAt ? formatDate(exam.createdAt) : "N/A";
        let status = getStatusText(exam.activationStatus);
        let examTime = exam.examTime != null ? exam.examTime + "분" : "N/A";
        let entryIcon  = getEntryIcon(exam.entreeCode);
        let examId = exam.examId ?? "N/A";


        tableBody +=
                "<tr >" + "<tr data-exam-id='" + examId + "'>" +
                "<td>" + title + "</td>" +
                "<td>" + examCode + "</td>" +
                "<td>" + category + "</td>" +
                "<td>" + nickname + "</td>" +
                "<td>" + createdAt + "</td>" +
                "<td>" + status + "</td>" +
                "<td>" + examTime + "</td>" +
                "<td>" + entryIcon  + "</td>" +
                "</tr>";
      });

      $('#result-rows').html(tableBody);
    }

    // 검색 결과 클릭 시 examId 저장 (사용자가 검색 후 클릭한 시험 ID를 저장)
    $(document).on("click", "#result-rows tr", function () {
      let examId = $(this).data("exam-id"); // 올바른 data-exam-id 속성 가져오기
      if (examId) {
        localStorage.setItem("selectedExamId", examId); // localStorage에 examId 저장
        console.log("저장된 examId:", examId);
      } else {
        console.warn("클릭한 행에서 examId를 가져올 수 없습니다.");
      }
    });

    // 검색 페이지 시험 검색어 클릭 시 동작
    $(document).on("click", "#result-rows tr", function () {
      const examId = $(this).closest("tr").data("exam-id"); // 시험ID 추출
      const examCode = $(this).find("td:nth-child(2)").text().trim(); // 시험코드 추출
      const entreeCode = $(this).find("td:nth-child(8) i").data("entree-code"); // 입장코드 추출

      if (!CURRENT_USER_ID) {
        alert("로그인이 필요합니다.");
        return; // 현재 로그인한 사용자 : examineeId가 없으면 중단
      }

      console.log(entreeCode);

      let userEntreeCode = "<null>";

      if (entreeCode !== "<null>") {
        // 비공개 시험일 경우, 사용자에게 비밀번호 입력 요청
        userEntreeCode = prompt("비공개 시험입니다. 입장 코드를 입력하세요:");

        if (userEntreeCode === null) {
          alert("입장 취소됨.");
          return;
        }

        // 입력한 입장 코드가 올바른지 검사
        if (String(userEntreeCode)!== String(entreeCode)) {
          alert("입장 코드가 올바르지 않습니다.");
          return;
        }

      }


      console.log(userEntreeCode);

      // Ajax 요청
      $.ajax({
        url: `/api/exams/results/join/` + examId, // 백엔드의 경로
        type: "GET",
        data: {
          examCode: examCode,
          entreeCode: userEntreeCode, // 공개방일 경우 빈 값 전달
          examineeId: CURRENT_USER_ID,
        },
        success: function (response) {
          console.log("응시 페이지 입장 성공:", response);
          window.location.href = "/api/exams/results/exam/take"; // 시험 응시 페이지로 이동
        },
        error: function (xhr, status, error) {
          console.error("응시 페이지 입장 실패", status, error);
          alert("응시 페이지로 이동할 수 없습니다.");
        },
      });
    });


    // 아래는 유틸함수
    // 날짜 포맷 함수
    function formatDate(dateString) {
      let date = new Date(dateString);
      return date.toISOString().slice(0, 19).replace("T", " "); // yyyy-MM-dd 형식 반환
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
    $('#filter-category, #filter-status, #filter-examTime, #filter-roomType').on('change', function () {
      applyFilters();
    });

    // 필터 초기화 버튼 클릭 시 모든 필터를 기본값으로 설정
    $('#reset-filters').on('click', function () {
      $('#filter-category').val('');
      $('#filter-creator').val('');
      $('#filter-createdAt').val('');
      $('#filter-status').val('');
      $('#filter-examTime').val('');
      $('#filter-roomType').val('');

      applyFilters(); // 초기화 후 필터 적용 (기본 상태 검색)
    });


  });
</script>