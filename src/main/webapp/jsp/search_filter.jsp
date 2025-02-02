<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>

<!-- 필터 UI -->
<div class="filter-container">
  <div class="filter-options">
    <input type="text" id="filter-title" class="filter-input" placeholder="시험명 입력">
    <select id="filter-category" class="filter-select">
      <option value="">카테고리 선택</option>
      <option value="프로그래밍">프로그래밍</option>
      <option value="수학">수학</option>
      <option value="과학">과학</option>
    </select>
    <input type="text" id="filter-creator" class="filter-input" placeholder="생성자 입력">
    <input type="date" id="filter-createdAt" class="filter-input">
    <select id="filter-status" class="filter-select">
      <option value="">상태 선택</option>
      <option value="not_started">시험 전</option>
      <option value="on_going">시험 중</option>
      <option value="closed">시험 종료</option>
    </select>
    <select id="filter-examTime" class="filter-select">
      <option value="">시험시간 선택</option>
      <option value="30">30분</option>
      <option value="60">60분</option>
      <option value="90">90분</option>
      <option value="120">120분</option>
    </select>
  </div>
</div>
