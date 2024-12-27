<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원가입</title>
<script>
    document.addEventListener("DOMContentLoaded", () => {
        const handleAuthButton = document.getElementById("handleAuthButton");
        const handleInput = document.getElementById("handle");
        const dynamicElementsContainer = document.getElementById("dynamicElements");
        const signupForm = document.getElementById("signupForm");
        const loadingOverlay = document.getElementById("loadingOverlay");

        let isDynamicElementsVisible = false;
        let isHandleAuthSuccessful = false; // 핸들 인증 상태 추가

        handleAuthButton.addEventListener("click", () => {
            if (!isDynamicElementsVisible) {
                const problemInput = document.createElement("input");
                problemInput.type = "text";
                problemInput.id = "problem";
                problemInput.placeholder = "문제번호를 입력하세요";

                const confirmButton = document.createElement("button");
                confirmButton.id = "confirmButton";
                confirmButton.textContent = "확인";

                dynamicElementsContainer.appendChild(problemInput);
                dynamicElementsContainer.appendChild(confirmButton);

                confirmButton.addEventListener("click", async () => {
                    const handle = handleInput.value;
                    const problem = problemInput.value;

                    if (!handle || !problem) {
                        alert("핸들과 문제번호를 입력해주세요.");
                        return;
                    }

                    loadingOverlay.style.display = "block";

                    try {
                        const response = await fetch("http://localhost:8080/auth/handle-auth", {
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
                            isHandleAuthSuccessful = true; // 핸들 인증 성공 상태 설정
                        } else {
                            alert("핸들 인증에 실패했습니다.");
                            isHandleAuthSuccessful = false;
                        }
                    } catch (error) {
                        console.error("Error during handle authentication:", error);
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

            if (!isHandleAuthSuccessful) { // 핸들 인증이 성공하지 않았을 경우
                alert("핸들 인증이 완료되지 않았습니다.");
                return;
            }

            try {
                const response = await fetch("http://localhost:8080/user/join", {
                    method: "POST",
                    headers: {
                        "Content-Type": "application/json"
                    },
                    body: JSON.stringify({ userId, pw, handle })
                });

                if (response.ok) {
                    alert("회원가입 성공!");
                } else {
                    alert("회원가입에 실패했습니다.");
                }
            } catch (error) {
                console.error("Error during signup:", error);
                alert("서버 오류가 발생했습니다.");
            }
        });
    });
</script>
<style>
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
</head>
<body>
    <div id="loadingOverlay">로딩 중...</div>
    <h1>회원가입</h1>
    <form id="signupForm">
        <input type="text" id="userId" placeholder="아이디" required><br>
        <input type="password" id="pw" placeholder="비밀번호" required><br>
        <input type="text" id="handle" placeholder="핸들" required>
        <button type="button" id="handleAuthButton">핸들 인증</button><br>
        <div id="dynamicElements"></div>
        <button type="submit">회원가입</button>
    </form>
</body>
</html>
