<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<title>Time Limit Problem</title>
<style>
body {
	font-family: 'Arial', sans-serif;
	background-color: #f7f9fc;
	margin: 0;
	padding: 0;
}

.container {
	max-width: 600px;
	margin: 50px auto;
	background-color: #ffffff;
	padding: 20px;
	border-radius: 8px;
	box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
}

h1 {
	text-align: center;
	font-size: 24px;
	color: #333333;
	margin-bottom: 20px;
}

p {
	font-size: 16px;
	color: #555555;
	margin-bottom: 10px;
}

a {
	color: #007bff;
	text-decoration: none;
}

a:hover {
	text-decoration: underline;
}

select {
	width: 100%;
	padding: 10px;
	font-size: 16px;
	margin-top: 10px;
	margin-bottom: 20px;
	border: 1px solid #cccccc;
	border-radius: 4px;
}

button {
	width: 100%;
	padding: 12px;
	font-size: 16px;
	border: none;
	border-radius: 6px;
	cursor: pointer;
	margin-bottom: 10px;
	transition: background-color 0.3s;
}

button:hover {
	opacity: 0.9;
}

.btn-primary {
	background-color: #007bff;
	color: #ffffff;
}

.btn-secondary {
	background-color: #6c757d;
	color: #ffffff;
}

.btn-warning {
	background-color: #ffc107;
	color: #212529;
}

.time-status {
	margin: 20px 0;
	padding: 15px;
	background-color: #f9f9f9;
	border: 1px solid #dddddd;
	border-radius: 6px;
	text-align: center;
}

.time-status span {
	font-weight: bold;
	color: #333333;
}

.center {
	text-align: center;
}
</style>
<script>
    const BASE_URL = "${gatewayUrl}"; // API 요청 기본 URL
	const handle = localStorage.getItem("handle");

    // 서버에서 전달받을 것;
/*	const problemId = "${problemId}"; */
/*	const limitTime = "${limitTime}";*/

    const dummyData = {
        problemId: 1001,
        limitTime: 30 // 제한 시간 (분 단위) 임의 더비값
    };

    let startTime; // 시작 시간 : 페이지 onload될 때 셋 되게 했
    let timerInterval; // 타이머 ID

    // 타이머 업데이트 함수 
    function updateTimer() {
        const timeLeftElement = document.getElementById("timeLeft");

        if (!timeLeftElement) {
            console.error("timeLeft 요소를 찾을 수 없습니다!");
            return;
        }

        const currentTime = new Date();
        const elapsedSeconds = Math.floor((currentTime - startTime) / 1000);
        const remainingSeconds = dummyData.limitTime * 60 - elapsedSeconds;

        if (remainingSeconds <= 0) {
            timeLeftElement.textContent = "실패!";
            clearInterval(timerInterval); // 타이머 중단
            saveSubmission("FAIL"); // 실패 상태 저장
            return;
        }

        
        // 남은 시간 출력해주는 부분
        const minutes = Math.floor(remainingSeconds / 60);
        const seconds = remainingSeconds % 60;
        timeLeftElement.textContent = minutes + "분 " + (seconds < 10 ? "0" : "") + seconds + "초";
    }

    // 풀이 여부 체크 
    function checkSubmission() {
        const url = BASE_URL + "/submissions/result?handle=" + handle + "&problemId=" + dummyData.problemId;

        fetch(url)
            .then(response => response.text())
            .then(data => {
                console.log("응답 데이터:", data);
                const status = data.trim();
                document.getElementById("status").innerText = status === "SUCCESS" ? "SUCCESS" : "FAIL";

                if (status === "SUCCESS") {
                    saveSubmission(status);
                    incrementScore(); // 점수 증가 호출
                } else {
                    alert("풀이 실패! 코드를 다시 작성해 보세요.");
                }
            })
            .catch(err => console.error("API 호출 중 오류 발생:", err));
    }

    // 풀이 로그 저장 함수 
    function saveSubmission(status) {
        const language = document.getElementById("language").value;
        const url = BASE_URL + "/submissions/save";

        // 시간 형식 맞추기 (시작 시간을 시간:분 으로 해서 일어나는 거 같은데 아예 시작 시간 형태를 수정해도 좋을 듯 )
        const formattedStartTime = startTime.getFullYear() +
            "-" + (startTime.getMonth() + 1).toString().padStart(2, "0") +
            "-" + startTime.getDate().toString().padStart(2, "0") +
            "T" + startTime.getHours().toString().padStart(2, "0") +
            ":" + startTime.getMinutes().toString().padStart(2, "0") +
            ":" + startTime.getSeconds().toString().padStart(2, "0");

        // 언어 설정이 없는 거 같은데 우리 요청에 있길래 일단 select로 받두게 해서 추가함
        const requestBody = {
            handle: handle,
            problemId: dummyData.problemId,
            startTime: formattedStartTime,
            limitTime: dummyData.limitTime,
            language: language,
            status: status
        };

        console.log("요청 데이터:", requestBody);

        fetch(url, {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify(requestBody)
        })
            .then(response => {
                if (response.status === 201) {
                    alert("풀이 결과가 저장되었습니다.");
                    window.location.href = "/problem/rank?problemId=" + dummyData.problemId;
                } else {
                    console.error("응답 상태 코드:", response.status);
                    alert("결과 저장에 실패했습니다. 상태 코드: " + response.status);
                }
            })
            .catch(err => console.error("API 호출 중 오류 발생:", err));
    }

	// 사용자 점수 +1
    function incrementScore() {
        const incrementScoreUrl = BASE_URL + "/stats/rank/increment-score?handle=" + handle;

        fetch(incrementScoreUrl, {method: "POST"})
            .then(response => {
                if (response.ok) {
                    alert("점수가 성공적으로 업데이트되었습니다!");
                } else {
                    alert("점수 업데이트에 실패했습니다. 상태 코드: " + response.status);
                }
            })
            .catch(err => console.error("점수 증가 중 오류 발생:", err));
    }

    window.onload = function () {
        startTime = new Date();
        const formattedStartTime = startTime.getHours().toString().padStart(2, "0") + ":" +
                                   startTime.getMinutes().toString().padStart(2, "0");

        console.log("시작 시간:", formattedStartTime);

        document.getElementById("problemLink").innerText = dummyData.problemId;
        document.getElementById("problemLink").href = "https://www.acmicpc.net/problem/" + dummyData.problemId;
        document.getElementById("startTime").innerText = formattedStartTime;
        document.getElementById("limitTime").innerText = dummyData.limitTime + "분";

        updateTimer();
        timerInterval = setInterval(updateTimer, 1000);
    };
</script>
</head>
<body>
	<div class="container">
		<h1>문제 풀이 페이지</h1>
		<p>문제 링크: <a id="problemLink" target="_blank"></a></p>
		<div class="time-status">
			<p>시작 시간: <span id="startTime"></span></p>
			<p>제한 시간: <span id="limitTime"></span></p>
			<p>남은 시간: <span id="timeLeft"></span></p>
			<p>풀이 상태: <span id="status"></span></p>
		</div>
		<label for="language">사용 언어:</label>
		<select id="language">
			<option value="Java">Java</option>
			<option value="Python">Python</option>
			<option value="C++">C++</option>
		</select>
		<button class="btn btn-primary" onclick="checkSubmission()">풀이 완료</button>
		<button class="btn btn-secondary" onclick="history.back()">돌아가기</button>
		<button class="btn btn-warning" onclick="window.location.href='/'">홈</button>
	</div>
</body>
</html>
