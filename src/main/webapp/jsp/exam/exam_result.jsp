<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Main Dashboard</title>
    <link rel="stylesheet" href="/css/exam_result.css">
</head>
<body>
<div class="main-container">
    <%@ include file="/jsp/sidebar.jsp" %>

    <%--    sidebar랑 메인이랑 분리  --%>
    <main class="content">
        <header class="header">
            <h1>이전 응시 내역</h1>
        </header>
        <div class="divider"></div>
        <div class="search-bar">
            <input type="text" placeholder="검색해보세용">
            <i class="icon-search"></i>
        </div>
        <div class="sort-dropdown">
            <select id="sortOrder" name="sortOrder" onchange="handleSortChange()">
                <option value="latest">최신순</option>
                <option value="oldest">오래된 순</option>
            </select>
        </div>
        <div class="filter-container">
            <button class="filter-button" onclick="toggleFilterMenu()">필터 ▼</button>
            <div class="filter-menu" id="filterMenu">
                <label><input type="checkbox" name="filter" value="option1">진행전</label>
                <label><input type="checkbox" name="filter" value="option2">진행후</label>
                <label><input type="checkbox" name="filter" value="option3">검토완료</label>
            </div>
        </div>
        <section class="dashboard-grid">
            <div class="dashboard-card">
                <h3>Statistics</h3>
                <p>Some detailed statistics...</p>
            </div>
            <div class="dashboard-card">
                <h3>Source Visits</h3>
                <p>Visit breakdown...</p>
            </div>
            <div class="dashboard-card project-list">
                <h3>Project List</h3>
                <ul>
                    <li>Project 1 - In Progress</li>
                    <li>Project 2 - Completed</li>
                    <li>Project 3 - Pending</li>
                </ul>
            </div>
            <div class="dashboard-card project-list">
                <h3>Project List</h3>
                <ul>
                    <li>Project 1 - In Progress</li>
                    <li>Project 2 - Completed</li>
                    <li>Project 3 - Pending</li>
                </ul>
            </div>
            <div class="dashboard-card project-list">
                <h3>Project List</h3>
                <ul>
                    <li>Project 1 - In Progress</li>
                    <li>Project 2 - Completed</li>
                    <li>Project 3 - Pending</li>
                </ul>
            </div>
            <div class="dashboard-card project-list">
                <h3>Project List</h3>
                <ul>
                    <li>Project 1 - In Progress</li>
                    <li>Project 2 - Completed</li>
                    <li>Project 3 - Pending</li>
                </ul>
            </div>
        </section>
    </main>
    <script>
        function handleSortChange() {
            const sortOrder = document.getElementById('sortOrder').value;
            if (sortOrder === 'latest') {
                // 최신순 정렬 로직 추가
            } else if (sortOrder === 'oldest') {
                // 오래된 순 정렬 로직 추가
            }
        }

        function toggleFilterMenu() {
            const filterMenu = document.getElementById('filterMenu');
            filterMenu.style.display = filterMenu.style.display === 'block' ? 'none' : 'block';
        }

    </script>
</div>
</body>
</html>