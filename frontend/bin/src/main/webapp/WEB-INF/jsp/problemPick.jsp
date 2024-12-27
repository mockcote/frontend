<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html>
<head>
    <title>Problem Pick Page</title>
</head>
<body>
    <h1>문제 뽑기</h1>

    <!-- 서버에서 전달해 준 메시지(문제 정보) 표시 -->
    <p>${problemMessage}</p>

    <!-- 문제 뽑기 폼 (POST) -->
    <form action="/problem" method="post">
        <button type="submit">문제 뽑기</button>
    </form>

    <hr/>

    <a href="/time">타임 리밋 페이지로 이동</a>
</body>
</html>