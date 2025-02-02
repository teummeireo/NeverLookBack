<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>


<%-- 그라파나 대시보드를 통째로 들고오는 iframe => 간편하지만 사용자의 자유도가 높아져서 불안정함--%>
<iframe
    src="http://professortoofast.store:3000/d/eeaql3rgxfg1se/exam-statistics?kiosk=1&orgId=1&refresh=5m&from=now-15d&to=now&timezone=browser&var-exam_id=1"
    width="100%"
    height="1300"
    frameborder="0">
</iframe>


<%-- 그라파나 대시보드 중 패널 한가지를 가져오는 iframe => 재배치가 가능하지만 대시보드내 모든 패널을 가져오려면 여러번 해야함--%>
<iframe src=http://professortoofast.store:3000/d-solo/bebjlq5axmigwc/admin?orgId=1&refresh=5m&timezone=browser&panelId=1&__feature.dashboardSceneSolo" width="450" height="200" frameborder="0"></iframe>
</body>
</html>
