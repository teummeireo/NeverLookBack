<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>시험/답안 관리</title>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/submission_check.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/sidebar.css">
</head>
<body>
<div class="main-container">
    <%@ include file="/jsp/sidebar.jsp" %>
    <main class="content">
        <div class="container">
            <div class="header">
                <h1>시험/답안 관리</h1>
            </div>
        </div>
    </main>
</div>




<script src="https://code.jquery.com/jquery-3.7.1.js"></script>
<script>
    $(document).ready(function() {
        // sortBy = ~~~;  정렬 매개 : createAt, title, examineeCount, category
        // order = ~~~; ASC , DESC
        // category = ~~~;

        $.ajax({
            url: "/api/admin/exams",
            method: 'GET',
            data: "sortBy=" + sortBy + "&order=" + order + "&category=" + category,
            dataType: "json",
            success: function(obj) {
                console.log("응답:" + obj);
            },
            error: function(xhr, status, error) {
                console.log("에러:", status);
                alert(xhr.responseJSON.error);
            }
        });






    });
</script>

</body>
</html>
