<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/sidebar.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/created_exam.css">
    <title>시험생성하기</title>
</head>
<body>
<div class="main-container">
    <%@ include file="/jsp/sidebar.jsp" %>
    <main class="content">
        <header class="header">
            <h1>초기 데이터 설정</h1>
        </header>
        <div class="divider"></div>

        <div class="exam-creator-container">
            <div class="exam-creator">
                <h2>시험 정보 입력</h2>
                <form id="exam-creator-form">
                    <div class="form-group exam-title">
                        <label for="exam-title">시험 제목</label>
                        <input type="text" id="exam-title" name="examTitle" placeholder="시험 제목을 입력하세요">
                    </div>
                    <div class="form-group exam-code">
                        <label for="exam-code">시험 코드</label>
                        <input type="text" id="exam-code" name="examCode" placeholder="시험 코드를 입력하세요">
                    </div>
                    <div class="form-group category">
                        <label for="category">카테고리</label>
                        <select id="category" name="category">
                            <option value="" disabled selected>카테고리를 선택하시오</option>
                            <option value="Programming">Programming</option>
                            <option value="Java">Java</option>
                            <option value="C">C</option>
                            <option value="C++">C++</option>
                            <option value="C#">C#</option>
                            <option value="Python">Python</option>
                        </select>
                    </div>
                    <div class="form-group entree-code">
                        <label for="entree-code">입장 비밀번호</label>
                        <input type="text" id="entree-code" name="entreeCode" placeholder="비밀번호를 선택하시오">
                    </div>
                    <div class="form-group exam-time">
                        <label for="exam-time">시험 시간 (분)</label>
                        <input type="number" id="exam-time" name="examTime" placeholder="시험 시간을 입력하세요" min="1">
                    </div>
                    <div class="form-group exam-dates">
                        <label for="started-at">시작 시간</label>
                        <input type="datetime-local" id="started-at" name="startedAt">
                    </div>
                    <div class="form-group exam-dates">
                        <label for="finished-at">종료 시간</label>
                        <input type="datetime-local" id="finished-at" name="finishedAt">
                    </div>
                    <button type="button" id="submit-exam" class="btn">문제 생성하러 가기</button>
                </form>
            </div>
        </div>
    </main>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script>
        $(document).ready(function() {
            $('#submit-exam').on('click', function() {
                var examVO = {
                    createrId: ${sessionScope.userId}, // 세션에서 UserId 가져오기
                    examCode: $('#exam-code').val(),
                    title: $('#exam-title').val(),
                    category: $('#category').val(),
                    entreeCode: $('#entree-code').val(),
                    startedAt: $('#started-at').val() + ':00', // 초 추가
                    finishedAt: $('#finished-at').val() + ':00', // 초 추가
                    examTime: $('#exam-time').val()
                };

                var requestData = {
                    examVO: examVO,
                    examMongoVO: {}
                };
                console.log(requestData);

                $.ajax({
                    url: '/api/exams/init',
                    method: 'POST',
                    contentType: 'application/json; charset=UTF-8',
                    data: JSON.stringify(requestData),
                    success: function(response) {
                        alert('시험이 생성되었습니다!');
                        console.log(response);
                        location.href = '/exams/create-exam?examId=' + response.data;
                    },
                    error: function(response) {
                        console.error('에러:');
                        alert('시험 생성에 실패했습니다: ' + response);
                    }
                });
            });
        });
    </script>
</body>
</html>
