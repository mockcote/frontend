<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>JSP Frontend</title>
</head>
<body>
    <h1>JSP Frontend Page</h1>
    <p>Message: ${message}</p>

    <!-- Ajax 요청으로 Gateway를 거쳐 백엔드 서버를 호출하는 예시 -->
    <script>
        fetch('/gateway-api/hello')
            .then(response => response.json())
            .then(data => {
                console.log("API Response:", data);
            });
    </script>
</body>
</html>
