<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<script>
  $(document).ready(function () {
    // 특정 검색어 삭제
    $(document).on('click', '.delete-search', function () {
      const searchTerm = $(this).data('term'); // data-term 값 가져오기
      console.log(searchTerm);

      $.ajax({
        url: '/api/search-history/delete', // API URL
        type: 'POST',
        data: {
          userId: CURRENT_USER_ID,
          searchTerm: searchTerm
        },
        success: function (data) {
          console.log("삭제된 검색어:", searchTerm);
          loadRecentSearches(); // 삭제 후 목록 갱신
        },
        error: function (xhr, status, error) {
          console.error("특정 검색어 삭제 실패:", status, error);
        }
      });
    });

    // 전체 검색어 삭제
    $('#clear-all-btn').on('click', function () {
      $.ajax({
        url: '/api/search-history/clear', // API URL
        type: 'POST',
        data: { userId: CURRENT_USER_ID }, // 현재 사용자 ID 전달
        success: function () {
          console.log("전체 검색어 삭제 완료");
          loadRecentSearches(); // 삭제 후 목록 갱신
        },
        error: function (xhr, status, error) {
          console.error("전체 검색어 삭제 실패:", status, error);
        }
      });
    });

    // 최근 검색어 목록 로드 함수
    function loadRecentSearches() {
      $.ajax({
        url: '/api/search-history/recent',
        type: 'GET',
        data: { userId: CURRENT_USER_ID },
        success: function (data) {
          let list = $('#recent-searches');
          list.empty();

          if (data.length > 0) {
            data.forEach(item => {
              list.append(
                  '<li>' +
                  '<span class="search-term">' + item.searchTerm + '</span>' +
                  '<button class="delete-search" data-term="' + item.searchTerm + '" type="button">X</button>' +
                  '</li>'
              );
            });
            $('#recent-searches-container').removeClass('hidden').show();
          } else {
            list.append('<li style="text-align: center; font-weight: bold;">최근 검색 결과 없음</li>');
          }

          $('#recent-searches-container').removeClass('hidden').show();
        },
        error: function (xhr, status, error) {
          console.error("최근 검색어 목록 로드 실패:", status, error);
        }
      });
    }

    // 검색창 클릭 시 최근 검색어 열기 + 스타일 변경
    $('#search-input').on('focus', function () {
      loadRecentSearches();
      $('#recent-searches-container').removeClass('hidden').show();

      // placeholder 변경
      $(this).attr('placeholder', '검색어를 입력하세요.');

      // CSS 클래스 추가 (search-bar의 테두리 제거)
      $('.search-bar').addClass('search-bar-focus');
    });

    // 검색창에서 Enter 키 입력 시 최근 검색어 닫기
    $('#search-input').on('keypress', function (event) {
      if (event.which === 13) { // Enter 키 코드
        $('#recent-searches-container').addClass('hidden').hide(); // 최근 검색어 닫기
      }
    });

    // 닫기 버튼 클릭 시 최근 검색어 닫기
    $('#close-recent-searches').on('click', function () {
      $('#recent-searches-container').addClass('hidden').hide();
    });

    // 검색창 외부 클릭 시 원래 상태로 복귀
    $(document).on('click', function (event) {
      if (!$(event.target).closest('#search-input').length &&
          !$(event.target).closest('#recent-searches-container').length) {
        $('#recent-searches-container').addClass('hidden').hide();

        // placeholder 원래대로 변경
        $('#search-input').attr('placeholder', '');

        // CSS 클래스 추가 (search-bar의 테두리 제거)
        $('.search-bar').removeClass('search-bar-focus');
      }
    });


  });
</script>