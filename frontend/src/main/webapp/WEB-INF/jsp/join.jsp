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
    margin-top: 20px;
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

/* 문제번호 안내 메시지 스타일 */
#problemMessageContainer {
    background-color: #e9f7fe;
    border: 1px solid #007bff;
    border-radius: 8px;
    padding: 15px;
    margin-top: 15px;
    text-align: center;
}

/* 문제번호 텍스트 스타일 */
#problemMessageContainer p {
    color: #0056b3;
    font-weight: bold;
}

/* 하이퍼링크 스타일 */
#problemLink {
    display: inline-block;
    margin-top: 10px;
    padding: 10px 20px;
    background-color: #007bff;
    color: #ffffff;
    text-decoration: none;
    border-radius: 4px;
    font-size: 16px;
    cursor: pointer;
}

/* 하이퍼링크 hover 효과 */
#problemLink:hover {
    background-color: #0056b3;
}

/* 코드 제출 완료 버튼 스타일 */
#submitCodeButton {
    margin-top: 10px;
    padding: 10px 20px;
    background-color: #28a745;
    color: #ffffff;
    border: none;
    border-radius: 4px;
    font-size: 16px;
    cursor: pointer;
}

/* 코드 제출 완료 버튼 hover 효과 */
#submitCodeButton:hover {
    background-color: #218838;
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
        let problemId = null; // 문제 번호 저장

        // 핸들 인증 버튼 클릭 이벤트
        handleAuthButton.addEventListener("click", async () => {
            if (!isDynamicElementsVisible) {
                loadingOverlay.style.display = "block";

                try {
                    // 문제 번호 요청
                    const response = await fetch(BASE_URL + "/problems/problem/random");
                    if (response.ok) {
                        // 문제 번호 가져오기
                        problemId = await response.text();

                        console.log("problemId: ", problemId);

                        // 문제 번호 안내 메시지 추가
                        const messageContainer = document.createElement("div");
                        messageContainer.id = "problemMessageContainer";

                        const messageText = document.createElement("p");
                        messageText.textContent = "문제번호: " + problemId + " 로 백준에서 코드를 제출하세요.";

                        // 백준 문제로 이동하는 링크 추가
                        const problemLink = document.createElement("a");
                        problemLink.id = "problemLink";
                        problemLink.href = "https://www.acmicpc.net/problem/"+problemId;
                        problemLink.target = "_blank"; // 새 창에서 열기
                        problemLink.textContent = "문제 풀러 가기";

                        // 코드 제출 완료 버튼 추가
                        const submitCodeButton = document.createElement("button");
                        submitCodeButton.id = "submitCodeButton";
                        submitCodeButton.textContent = "코드 제출 완료";

                        // 코드 제출 완료 버튼 이벤트 핸들러
                        submitCodeButton.addEventListener("click", async () => {
                            const handle = handleInput.value;
                            if (!handle) {
                                alert("핸들을 입력하세요.");
                                return;
                            }

                            loadingOverlay.style.display = "block";

                            try {
                                // 핸들 인증 요청
                                const authResponse = await fetch(BASE_URL + "/auth/handle-auth", {
                                    method: "POST",
                                    headers: {
                                        "Content-Type": "application/json"
                                    },
                                    body: JSON.stringify({ handle, problem: problemId })
                                });

                                if (authResponse.ok) {
                                    alert("핸들 인증이 완료되었습니다.");
                                    dynamicElementsContainer.innerHTML = ""; // 동적 요소 제거
                                    handleAuthButton.disabled = true; // 핸들 인증 버튼 비활성화
                                    isDynamicElementsVisible = false;
                                    isHandleAuthSuccessful = true;
                                } else {
                                    alert("핸들 인증에 실패했습니다.");
                                }
                            } catch (error) {
                                console.error("핸들 인증 중 오류 발생:", error);
                                alert("서버 오류가 발생했습니다.");
                            } finally {
                                loadingOverlay.style.display = "none";
                            }
                        });

                        // 동적 요소 추가
                        dynamicElementsContainer.innerHTML = ""; // 기존 요소 제거
                        dynamicElementsContainer.appendChild(messageContainer);
                        messageContainer.appendChild(messageText);
                        messageContainer.appendChild(problemLink);
                        messageContainer.appendChild(submitCodeButton);

                        isDynamicElementsVisible = true;
                    } else {
                        console.error("HTTP 상태 코드:", response.status);
                        console.error("응답 내용:", await response.text());
                        alert("문제 번호를 가져오는 데 실패했습니다.");
                    }
                } catch (error) {
                    console.error("문제 번호 요청 중 오류 발생:", error);
                    alert("서버 오류가 발생했습니다.");
                } finally {
                    loadingOverlay.style.display = "none";
                }
            } else {
                dynamicElementsContainer.innerHTML = ""; // 동적 요소 제거
                isDynamicElementsVisible = false;
            }
        });

        // 회원가입 제출 이벤트
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
                	window.location.href = "/login"; // 로그인 페이지로 이동
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
