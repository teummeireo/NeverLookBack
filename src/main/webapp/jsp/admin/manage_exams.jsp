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
        <div class="divider"></div>
        <table id="examTable" border="1">
            <thead>
            <tr>
                <th>시험 ID</th>
                <th>시험 코드</th>
                <th>시험 제목</th>
                <th>카테고리</th>
                <th>진행 상태</th>
                <th>시험 삭제</th>
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
            url: "${pageContext.request.contextPath}/api/admin/exams",
            method: 'GET',
            data: { sortBy: sortBy, order: order, category: category },
            dataType: "json",
            success: function(response) {
                let tbody = $("#examTable tbody");
                tbody.empty();

                $.each(response.data, function(index, exam) {
                    let row = "<tr>" +
                        "<td>" + exam.examId + "</td>" +
                        "<td>" + exam.examCode + "</td>" +
                        "<td>" + exam.title + "</td>" +
                        "<td>" + exam.category + "</td>" +
                        "<td>" +
                        "<select class='status-select' data-exam-id='" + exam.examId + "'>" +
                        "<option value='" + exam.activationStatus + "' selected>" + exam.activationStatus + "</option>" +
                        (exam.activationStatus !== 'not_started' ? "<option value='not_started'>not_started</option>" : "") +
                        (exam.activationStatus !== 'on_going' ? "<option value='on_going'>on_going</option>" : "") +
                        (exam.activationStatus !== 'closed' ? "<option value='closed'>closed</option>" : "") +
                        "</select>" +
                        "</td>" +
                        "<td>" +
                        "<button class='delete-btn' data-exam-id='" + exam.examId + "'>삭제</button>" +
                        "</td>" +
                        "</tr>";
                    tbody.append(row);
                });

                $(document).off("change", ".status-select").on("change", '.status-select', function() {
                    var examId = $(this).data("exam-id");
                    var newStatus = $(this).val();
                    updateExamStatus(examId, newStatus);

                })


                $(document).off("click", ".delete-btn").on("click", ".delete-btn", function() {
                    var examId = $(this).data("exam-id");
                    if (confirm("정말 삭제하시겠습니까?")) {
                        deleteExam(examId);
                    }
                });
            },
            error: function(xhr, status, error) {
                console.error("에러:", status, error);
                alert("데이터를 불러오는데 실패했습니다.");
            }
        });
    }

    function updateExamStatus(examId, newStatus) {
        $.ajax({
            url: "/api/exams/" + examId + "/status?status=" + newStatus,
            method: "PUT",
            contentType: "application/x-www-form-urlencoded",
            success: function(response) {
                alert("시험 상태가 변경되었습니다.");
                loadExamList(); // 변경 후 목록 갱신
            },
            error: function(xhr, status, error) {
                console.error("에러:", status, error);
                alert("상태 변경에 실패했습니다.");
                loadExamList(); // 실패 시 원래 상태 복구
            }
        });
    }

    function deleteExam(examId) {
        $.ajax({
            url: "/api/exams/" + examId,
            method: "DELETE",
            contentType: "application/x-www-form-urlencoded",
            success: function(response) {
                alert("시험이 삭제되었습니다.");
                loadExamList();
            },
            error: function(xhr, status, error) {
                console.error("에러 : " + status, error);
                alert("시험 삭제가 되지 않았습니다.");
                loadExamList();
            }
        });
    }
</script>
</body>
</html>
