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
<script src="/js/authFetch.js"></script>
<script>
    const BASE_URL = "${gatewayUrl}"; // API 요청 기본 URL
	const handle = "${cookie.handle.value}";

    let startTime; // 시작 시간 : 페이지 onload될 때 셋 되게 했
    let timerInterval; // 타이머 ID

	// 풀이 시작
	function timeStart() {
    	
		return authFetch(BASE_URL + "/submissions/start", {
			method: "POST",
			headers: { "Content-Type": "application/json" },
			body: JSON.stringify({ handle: handle })
		})
			.then(res => res.text())
			.then(data => {
				startTime = new Date(data); // 서버에서 반환된 데이터를 Date 객체로 변환
				console.log("startTime 설정:", startTime);
			})
			.catch(err => {
				console.error("풀이 시작 중 오류 발생: ", err);
				throw err; // 오류를 호출한 쪽으로 전달
			});
	}

    // 타이머 업데이트 함수 
    function updateTimer() {
        const timeLeftElement = document.getElementById("timeLeft");

        if (!timeLeftElement) {
            console.error("timeLeft 요소를 찾을 수 없습니다!");
            return;
        }

        const currentTime = new Date();
        const elapsedSeconds = Math.floor((currentTime - startTime) / 1000);
        const remainingSeconds = ${limitTime} * 60 - elapsedSeconds;

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
        const url = BASE_URL + "/submissions/result?handle=" + handle + "&problemId=" + ${problemId};

        authFetch(url)
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
            problemId: ${problemId},
            startTime: formattedStartTime,
            limitTime: ${limitTime},
            language: language,
            status: status
        };

        console.log("요청 데이터:", requestBody);

        authFetch(url, {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify(requestBody)
        })
            .then(response => {
                if (response.status === 201) {
                    alert("풀이 결과가 저장되었습니다.");
                    /* window.location.href = "/problem/rank?problemId=" + ${problemId}; */
                    
                 // 부모 창에 작업 완료 메시지 보내기
                    if (window.opener) {
                        window.opener.postMessage('taskComplete', window.location.origin);
                    }

                    // 자식 창 닫기
                    window.close();
                    
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

        authFetch(incrementScoreUrl, {method: "POST"})
            .then(response => {
                if (response.ok) {
                    alert("점수가 성공적으로 업데이트되었습니다!");
                } else {
                    alert("점수 업데이트에 실패했습니다. 상태 코드: " + response.status);
                }
            })
            .catch(err => console.error("점수 증가 중 오류 발생:", err));
    }

	// 그만하기
	function back() {
		authFetch(BASE_URL+"/submissions/end", {
			method: "POST",
			headers: { "Content-Type": "application/json" },
            body: JSON.stringify({handle: handle})
		})
				.then(response => {
					if(response.status === 204) {
						
		                // 부모 창에 작업 완료 메시지 보내기
                    if (window.opener) {
                        window.opener.postMessage('stop', window.location.origin);
                    }

                    // 자식 창 닫기
                    window.close();
						
					}
				})
				.catch(err => console.error("뒤로가기 중 오류 발생: ", err));
	}
	
	// 자식 창
	window.addEventListener('message', (event) => {
	  if (event.origin !== window.location.origin) return; // 도메인 검증

	  if (event.data === 'logoutDetected') {
	    alert('로그아웃되었습니다. 다시 로그인해주세요.');
	    
	    // 여기서 end api 호출을 하디, 냅두고start할 때 체크를 하기 (authFetch.js에서 바로 자식창 닫고 부모창한테 이벤트 보내지 않은 이유는 혹시 여기서 end 호출해야 할까)
	    // 만약 여기서 end 호출 안 하고 문제 풀기에서 start 시 체크하게 된다면 authFetch에서 바로 부모로 이벤트 보내고, 자식창 바로 끌 예정
	    
	 // 부모 창에 메시지 전송
	    if (window.opener) {
	      window.opener.postMessage('redirectToLogin', window.location.origin);
	    }

	    // 자식 창 닫기
	    window.close();
	    
	  }
	});


	

	window.onload = async function () {
		try {
			// timeStart가 완료될 때까지 기다림
			await timeStart();

			console.log("timeStart 완료");
			console.log("시작 시간:", startTime);

			// 시작 시간 포맷팅
			const formattedStartTime = startTime.getHours().toString().padStart(2, "0") + ":" +
									   startTime.getMinutes().toString().padStart(2, "0");

			document.getElementById("problemLink").innerText = ${problemId};
			document.getElementById("problemLink").href = "https://www.acmicpc.net/problem/" + ${problemId};
			document.getElementById("startTime").innerText = formattedStartTime;

			document.getElementById("limitTime").innerText = ${limitTime} + "분";

			// 타이머 초기화 및 시작
			updateTimer();
			timerInterval = setInterval(updateTimer, 1000);

		} catch (error) {
			console.error("페이지 로드 중 오류 발생:", error);
			alert("페이지 로드 중 문제가 발생했습니다.");
		}
	};
</script>
</head>
<body>
	<div class="container">
		<h1>문제 풀이 페이지</h1>
		<p>
			문제 링크: <a id="problemLink" target="_blank"></a>
		</p>
		<div class="time-status">
			<p>
				시작 시간: <span id="startTime"></span>
			</p>
			<p>
				제한 시간: <span id="limitTime"></span>
			</p>
			<p>
				남은 시간: <span id="timeLeft"></span>
			</p>
			<p>
				풀이 상태: <span id="status"></span>
			</p>
		</div>
		<label for="language">사용 언어:</label> <select id="language">
			<option value="Java">Java</option>
			<option value="Python">Python</option>
			<option value="C++">C++</option>
		</select>
		<button class="btn btn-primary" onclick="checkSubmission()">풀이
			완료</button>
		<button class="btn btn-warning" onclick="back()">그만하기</button>
	</div>
</body>
</html>
