<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>로그인 페이지</title>
<style>
body {
    font-family: Arial, sans-serif;
    background-color: #f0f2f5;
    display: flex;
    justify-content: center;
    align-items: center;
    height: 100vh;
    margin: 0;
}

.login-container {
    background-color: #ffffff;
    padding: 20px;
    border-radius: 8px;
    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
    width: 300px;
}

h1 {
    text-align: center;
    margin-bottom: 20px;
}

.form-group {
    margin-bottom: 15px;
}

label {
    display: block;
    margin-bottom: 5px;
    font-weight: bold;
}

input {
    width: 100%;
    padding: 8px;
    box-sizing: border-box;
    border: 1px solid #ccc;
    border-radius: 4px;
}

.login-button {
    width: 100%;
    padding: 10px;
    background-color: #007bff;
    color: #fff;
    border: none;
    border-radius: 4px;
    cursor: pointer;
    font-size: 16px;
}

.login-button:hover {
    background-color: #0056b3;
}

.register-button {
    display: block;
    text-align: center;
    margin-top: 10px;
    color: #007bff;
    text-decoration: none;
    font-size: 14px;
}

.register-button:hover {
    color: #0056b3;
    text-decoration: underline;
}
</style>
</head>
<body>
    <div class="login-container">
        <h1>로그인</h1>
        <form id="loginForm">
            <div class="form-group">
                <label for="userId">아이디:</label>
                <input type="text" id="userId" name="userId" required>
            </div>
            <div class="form-group">
                <label for="password">비밀번호:</label>
                <input type="password" id="password" name="password" required>
            </div>
            <div class="form-group">
                <button type="button" class="login-button" onclick="submitLogin()">로그인</button>
            </div>
        </form>
        <div class="form-group">
            <a href="/join" class="register-button">회원가입</a>
        </div>
    </div>

    <script>
        const BASE_URL = "${gatewayUrl}";
        
        function submitLogin() {
            const userId = document.getElementById('userId').value;
            const password = document.getElementById('password').value;

            fetch(BASE_URL + '/auth/login', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({ userId, password }),
                credentials: 'include' // 쿠키 포함
            })
            .then(response => {
                if (response.ok) {
                    return response.json();
                } else {
                    throw new Error('로그인 실패');
                }
            })
            .then(data => {
                // 로컬 스토리지에 값 저장
                localStorage.setItem('accessToken', data.accessToken);
                alert('로그인에 성공했습니다.');
                console.log('저장된 데이터:', data);

                // 메인 페이지로 이동
                window.location.href = "/";
            })
            .catch(error => {
                console.error('로그인 오류:', error);
                alert(error.message);
            });
        }
    </script>
</body>
</html>
