<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>오류 발생</title>
    <style>
        body {
            font-family: 'Arial', sans-serif;
            background-color: #f8f9fa;
            color: #343a40;
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }

        .error-container {
            max-width: 600px;
            padding: 20px 30px;
            background-color: #ffffff;
            border-radius: 10px;
            box-shadow: 0px 4px 10px rgba(0, 0, 0, 0.1);
            text-align: center;
        }

        .error-container h1 {
            font-size: 2rem;
            color: #dc3545;
            margin-bottom: 15px;
        }

        .error-container p {
            font-size: 1rem;
            margin-bottom: 10px;
        }

        .error-container .error-message {
            font-weight: bold;
            color: #495057;
            margin-top: 10px;
            font-size: 1.2rem;
        }

        .error-container a {
            display: inline-block;
            margin-top: 20px;
            padding: 10px 20px;
            color: #ffffff;
            background-color: #007bff;
            text-decoration: none;
            border-radius: 5px;
            font-size: 1rem;
        }

        .error-container a:hover {
            background-color: #0056b3;
        }
    </style>
</head>
<body>
    <div class="error-container">
        <h1>오류가 발생했습니다</h1>
        <p>현재 요청을 처리하는 중 문제가 발생했습니다.</p>
        <p class="error-message">에러 코드: ${status}</p>
        <p class="error-message">에러 메시지: ${message}</p>
        <a href="/">홈으로 돌아가기</a>
    </div>
</body>
</html>