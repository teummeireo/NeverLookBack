<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>시험 통계</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/new_main.css">

</head>
<body>
<iframe
        src="http://professortoofast.store:3000/d/eeaql3rgxfg1se/exam-statistics?kiosk=1&orgId=1&refresh=5m&from=${createAt}&to=now&timezone=browser&var-exam_id=${examId}"
        width="100%"
        height="1300"
        frameborder="0">
</iframe>
</body>
</html>
