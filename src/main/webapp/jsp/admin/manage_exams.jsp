<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>시험/답안 관리</title>
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/manage_exam.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/sidebar.css">
</head>
<body>
<div class="main-container">
    <%@ include file="/jsp/sidebar.jsp" %>
    <main class="content">
        <header class="header">
            <h1>시험/답안 관리</h1>
        </header>
        <table id="examTable" border="1">
            <thead>
            <tr>
                <th>Exam ID</th>
                <th>Exam Code</th>
                <th>Title</th>
                <th>Category</th>
                <th>Activation Status</th>
            </tr>
            </thead>
            <tbody>
            <!-- 동적으로 데이터 추가 -->
            </tbody>
        </table>
    </main>
</div>

<script>
    $(document).ready(function() {
        loadExamList();
    });

    function loadExamList() {
        let sortBy = "createdAt";
        let order = "DESC";
        let category = "";

        $.ajax({
            url: "/api/admin/exams",
            method: 'GET',
            data: { sortBy: sortBy, order: order, category: category },
            dataType: "json",
            success: function(response) {
                console.log("응답:", response);

                // `tbody` 요소 가져오기
                let tbody = $("#examTable tbody");
                tbody.empty(); // 기존 데이터 삭제

                // `response.data`를 순회해야 함
                $.each(response.data, function(index, exam) {
                    let row = "<tr>" +
                        "<td>" + exam.examineeId + "</td>" +
                        "<td>" + exam.examCode + "</td>" +
                        "<td>" + exam.title + "</td>" +
                        "<td>" + exam.category + "</td>" +
                        "<td>" + exam.activationStatus + "</td>" +
                        "</tr>";

                    tbody.append(row); // tbody에 추가
                });
            },
            error: function(xhr, status, error) {
                console.error("에러:", status, error);
                alert("데이터를 불러오는데 실패했습니다.");
            }
        });
    }

</script>
</body>
</html>
