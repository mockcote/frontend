<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원가입</title>
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

.signup-container {
    background-color: #ffffff;
    padding: 20px;
    border-radius: 8px;
    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
    width: 350px;
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

button {
    width: 100%;
    padding: 10px;
    border: none;
    border-radius: 4px;
    cursor: pointer;
    font-size: 16px;
}

.signup-button {
    background-color: #28a745;
    color: #fff;
}

.signup-button:hover {
    background-color: #218838;
}

.handle-auth-button {
    background-color: #007bff;
    color: #fff;
    margin-top: 10px;
}

.handle-auth-button:hover {
    background-color: #0056b3;
}

#loadingOverlay {
    display: none;
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background: rgba(0, 0, 0, 0.5);
    color: white;
    font-size: 2rem;
    text-align: center;
    line-height: 100vh;
    z-index: 1000;
}
</style>
<script>
    const BASE_URL = "${gatewayUrl}";

    document.addEventListener("DOMContentLoaded", () => {
        const handleAuthButton = document.getElementById("handleAuthButton");
        const handleInput = document.getElementById("handle");
        const dynamicElementsContainer = document.getElementById("dynamicElements");
        const signupForm = document.getElementById("signupForm");
        const loadingOverlay = document.getElementById("loadingOverlay");

        let isDynamicElementsVisible = false;
        let isHandleAuthSuccessful = false;

        handleAuthButton.addEventListener("click", () => {
            if (!isDynamicElementsVisible) {
                const problemInput = document.createElement("input");
                problemInput.type = "text";
                problemInput.id = "problem";
                problemInput.placeholder = "문제 번호를 입력하세요";

                const confirmButton = document.createElement("button");
                confirmButton.id = "confirmButton";
                confirmButton.textContent = "확인";

                dynamicElementsContainer.appendChild(problemInput);
                dynamicElementsContainer.appendChild(confirmButton);

                confirmButton.addEventListener("click", async () => {
                    const handle = handleInput.value;
                    const problem = problemInput.value;

                    if (!handle || !problem) {
                        alert("핸들과 문제 번호를 입력해주세요.");
                        return;
                    }

                    loadingOverlay.style.display = "block";

                    try {
                        const response = await fetch(BASE_URL + "/auth/handle-auth", {
                            method: "POST",
                            headers: {
                                "Content-Type": "application/json"
                            },
                            body: JSON.stringify({ handle, problem })
                        });

                        if (response.ok) {
                            alert("핸들 인증이 완료되었습니다.");
                            dynamicElementsContainer.innerHTML = "";
                            handleAuthButton.disabled = true;
                            isDynamicElementsVisible = false;
                            isHandleAuthSuccessful = true;
                        } else {
                            alert("핸들 인증에 실패했습니다.");
                            isHandleAuthSuccessful = false;
                        }
                    } catch (error) {
                        console.error("핸들 인증 중 오류 발생:", error);
                        alert("서버 오류가 발생했습니다.");
                        isHandleAuthSuccessful = false;
                    } finally {
                        loadingOverlay.style.display = "none";
                    }
                });

                isDynamicElementsVisible = true;
            } else {
                dynamicElementsContainer.innerHTML = "";
                isDynamicElementsVisible = false;
            }
        });

        signupForm.addEventListener("submit", async (event) => {
            event.preventDefault();

            const userId = document.getElementById("userId").value;
            const pw = document.getElementById("pw").value;
            const handle = handleInput.value;

            if (!userId || !pw || !handle) {
                alert("모든 입력란을 채워주세요.");
                return;
            }

            if (!isHandleAuthSuccessful) {
                alert("핸들 인증이 완료되지 않았습니다.");
                return;
            }

            try {
                const response = await fetch(BASE_URL + "/user/join", {
                    method: "POST",
                    headers: {
                        "Content-Type": "application/json"
                    },
                    body: JSON.stringify({ userId, pw, handle })
                });

                if (response.ok) {
                    alert("회원가입에 성공했습니다!");
                } else {
                    alert("회원가입에 실패했습니다.");
                }
            } catch (error) {
                console.error("회원가입 중 오류 발생:", error);
                alert("서버 오류가 발생했습니다.");
            }
        });
    });
</script>
</head>
<body>
    <div id="loadingOverlay">로딩 중...</div>
    <div class="signup-container">
        <h1>회원가입</h1>
        <form id="signupForm">
            <div class="form-group">
                <label for="userId">아이디:</label>
                <input type="text" id="userId" placeholder="아이디를 입력하세요" required>
            </div>
            <div class="form-group">
                <label for="pw">비밀번호:</label>
                <input type="password" id="pw" placeholder="비밀번호를 입력하세요" required>
            </div>
            <div class="form-group">
                <label for="handle">핸들:</label>
                <input type="text" id="handle" placeholder="핸들을 입력하세요" required>
                <button type="button" id="handleAuthButton" class="handle-auth-button">핸들 인증</button>
            </div>
            <div id="dynamicElements"></div>
            <div class="form-group">
                <button type="submit" class="signup-button">회원가입</button>
            </div>
        </form>
    </div>
</body>
</html>
