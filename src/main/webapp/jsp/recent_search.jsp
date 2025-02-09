<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<script>
  $(document).ready(function () {
    // 최근 검색어 목록 로드
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
        },
        error: function (xhr, status, error) {
          console.error("최근 검색어 목록 로드 실패:", status, error);
        }
      });
    }

    // 검색창 클릭 시
    $('#search-input').on('focus', function () {
      let query = $(this).val().trim();

      if (query.length === 0) {
        // 검색어가 없으면 최근 검색어 표시
        loadRecentSearches();
        $('#recent-searches-container').removeClass('hidden').show();
        $('#autocomplete-container').addClass('hidden').hide();
      } else {
        // 검색어가 있으면 자동완성 표시
        $('#recent-searches-container').addClass('hidden').hide();
        $('#autocomplete-container').removeClass('hidden').show();
      }

      // 검색창 스타일 변경
      $('.search-bar').addClass('search-bar-focus');
    });

    // 검색 입력 시 (자동완성 요청)
    $('#search-input').on('keyup', function () {
      let query = $(this).val().trim();

      if (query.length > 0) {
        $.ajax({
          url: '/api/search-history/autocomplete',  // 🔹 URL 확인
          type: 'GET',
          data: { query: query },
          success: function (data) {
            console.log("자동완성 응답 데이터:", data);

            let list = $('#autocomplete-searches');
            list.empty();  // 기존 리스트 초기화

            if (data.length > 0) {
              data.forEach(title => {
                list.append(
                    '<li>' +
                    '<span class="autocomplete-item">' + title + '</span>' +
                    '</li>'
                );
              });

              console.log("자동완성 리스트 HTML:", $('#autocomplete-searches').html()); // 🔹 리스트가 추가되는지 확인

              // 🔹 자동완성 컨테이너 강제 표시
              setTimeout(function() {
                $('#autocomplete-container').removeClass('hidden').css('display', 'block');
              }, 50);

              $('#recent-searches-container').addClass('hidden').hide();
            } else {
              $('#autocomplete-container').addClass('hidden').hide();
              $('#recent-searches-container').removeClass('hidden').show();
            }
          },
          error: function (xhr, status, error) {
            console.error("자동완성 로드 실패:", status, error);
          }
        });
      } else {
        $('#autocomplete-container').addClass('hidden').hide();
        $('#recent-searches-container').removeClass('hidden').show();
      }
    });

    // 검색창 외부 클릭 시 닫기
    $(document).on('click', function (event) {
      if (!$(event.target).closest('#search-input').length &&
          !$(event.target).closest('#recent-searches-container').length &&
          !$(event.target).closest('#autocomplete-container').length) {
        $('#recent-searches-container').addClass('hidden').hide();
        $('#autocomplete-container').addClass('hidden').hide();
        $('.search-bar').removeClass('search-bar-focus');
      }
    });

    // 닫기 버튼 클릭 시 최근 검색어 닫기
    $('#close-recent-searches').on('click', function () {
      $('#recent-searches-container').addClass('hidden').hide();
    });

    // 자동완성 클릭 시 검색 실행
    $(document).on('click', '.autocomplete-item', function () {
      let selectedText = $(this).text();
      $('#search-input').val(selectedText);
      $('#search-btn').trigger('click');
    });

    // 최근 검색어 클릭 시 검색 실행
    $(document).on("click", ".search-term", function () {
      let searchTerm = $(this).text();
      $("#search-input").val(searchTerm);
      $("#search-btn").trigger("click");
    });
  });

</script>