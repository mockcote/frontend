<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Login Page</title>
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
		<h1>Login</h1>
		<form id="loginForm">
			<div class="form-group">
				<label for="userId">User ID:</label> <input type="text" id="userId"
					name="userId" required>
			</div>
			<div class="form-group">
				<label for="password">Password:</label> <input type="password"
					id="password" name="password" required>
			</div>
			<div class="form-group">
				<button type="button" class="login-button" onclick="submitLogin()">Login</button>
			</div>
		</form>
		<div class="form-group">
			<a href="/join" class="register-button">Sign Up</a>
		</div>
	</div>

	<script>
    const BASE_URL = "${gatewayUrl}";
        function submitLogin() {
            const userId = document.getElementById('userId').value;
            const password = document.getElementById('password').value;

            fetch(BASE_URL +'/auth/login', {
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
                    throw new Error('Login failed');
                }
            })
            .then(data => {
                // 로컬 스토리지에 값 저장
                localStorage.setItem('level', data.level);
                localStorage.setItem('handle', data.handle);
                localStorage.setItem('accessToken', data.accessToken);
                alert('Login successful');
                console.log('Stored data:', data);
            })
            .catch(error => alert(error.message));
        }
    </script>
</body>
</html>
