<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ page import="java.util.List, java.util.Map"%>
<jsp:include page="header.jsp" />
<html>
<head>
<title>문제 결과</title>
<style>
body {
	font-family: 'Arial', sans-serif;
	background-color: #f0f4f8;
	margin: 0;
	padding: 0;
}

.container {
	max-width: 800px;
	margin: 30px auto;
	background: #ffffff;
	padding: 20px;
	border-radius: 8px;
	box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
}

h1 {
	font-size: 28px;
	color: #333333;
	margin-bottom: 20px;
	text-align: center;
}

p {
	font-size: 16px;
	color: #555555;
	margin-bottom: 10px;
}

.problem-details {
	margin-top: 20px;
	padding: 15px;
	background-color: #f9f9f9;
	border: 1px solid #dddddd;
	border-radius: 6px;
}

.problem-details p {
	margin: 8px 0;
	font-size: 16px;
}

.problem-details ul {
	list-style-type: none;
	padding: 0;
	display: none; /* 태그 보기 버튼을 클릭하기 전에는 숨김 */
}

.problem-details ul li {
	background: #eaf3ff;
	color: #0056b3;
	padding: 8px;
	margin: 5px 0;
	border-radius: 4px;
}

.btn {
	padding: 12px 20px;
	font-size: 16px;
	border: none;
	border-radius: 6px;
	cursor: pointer;
	display: inline-block;
	margin: 10px 5px;
}

.btn-primary {
	background-color: #007bff;
	color: #ffffff;
}

.btn-primary:hover {
	background-color: #0056b3;
}

.btn-secondary {
	background-color: #6c757d;
	color: #ffffff;
}

.btn-secondary:hover {
	background-color: #5a6268;
}

.btn-warning {
	background-color: #ffc107;
	color: #212529;
}

.btn-warning:hover {
	background-color: #e0a800;
}

.center {
	text-align: center;
}

.toggle-tags-btn {
	margin-top: 10px;
	display: block;
	width: fit-content;
}
</style>
<script>

		let childWindow = null;

        function toggleTags() {
            const tagList = document.getElementById("tagList");
            const toggleButton = document.getElementById("toggleTagsButton");

            if (tagList.style.display === "none") {
                tagList.style.display = "block";
                toggleButton.textContent = "태그 숨기기";
            } else {
                tagList.style.display = "none";
                toggleButton.textContent = "태그 보기";
            }
        }

        function setLimitTime() {
            const limitTimeInput = document.getElementById("limitTime");
            const hiddenLimitTime = document.getElementById("hiddenLimitTime");
            hiddenLimitTime.value = limitTimeInput.value;
            
            
         // 값 검증
            if (!hiddenLimitTime.value || isNaN(hiddenLimitTime.value) || hiddenLimitTime.value <= 0) {
                alert("유효한 제한 시간을 입력해주세요!");
                return false;
            }

            return true;
        }
        
        function setLimitTimeAndOpenChild() {
            // 제한시간 설정 및 검증
            const isValid = setLimitTime();
            if (!isValid) return; // 제한시간이 유효하지 않으면 중단

            const problemId = "<%= request.getAttribute("problemId") %>"; // 문제 ID 가져오기
            const limitTime = document.getElementById("hiddenLimitTime").value; // 설정된 제한 시간
            
			const url = `/time?problemId=${problemId}&limitTime=` + limitTime;
            console.log("새 창 열기 URL:", url); // URL 확인용 로그
            
            // 자식 창 열기
            childWindow = window.open(
                url, // 자식 창 URL
                'childWindow',
                'width=800,height=600'
            );
        }

     // 자식 창 상태 변경 메시지 처리
        window.addEventListener("message", (event) => {
            if (event.origin !== window.location.origin) return; // 도메인 확인

            switch (event.data) {
                case 'taskComplete':
                    window.location.href = `/problem/rank?problemId=<%=request.getAttribute("problemId")%>`;
                    break;
                case 'stop':
                    window.location.href = "/problem";
                    break;
                case 'redirectToLogin':
                    window.location.href = "/login";
                    break;
                default:
                    console.warn("알 수 없는 메시지:", event.data);
            }
        });
    </script>
</head>
<body>
	<div class="container">
		<h1>문제 뽑기 결과</h1>

		<!-- 서버에서 전달된 메시지 표시 -->
		<p><%=request.getAttribute("problemMessage")%></p>

		<!-- 문제 정보 표시 -->
		<div class="problem-details">
			<p>
				<strong>문제 번호:</strong>
				<%=request.getAttribute("problemId")%></p>
			<p>
				<strong>문제 제목:</strong>
				<%=request.getAttribute("problemInfo") != null ? ((Map<String, Object>) request.getAttribute("problemInfo")).get("title") : "N/A"%></p>
			<p>
				<strong>난이도:</strong>
				<%=request.getAttribute("problemInfo") != null ? ((Map<String, Object>) request.getAttribute("problemInfo")).get("levelName") : "N/A"%></p>
			<p>
				<strong>제출한 사용자 수:</strong>
				<%=request.getAttribute("problemInfo") != null ? ((Map<String, Object>) request.getAttribute("problemInfo")).get("acceptableUserCount") : "N/A"%></p>
			<button id="toggleTagsButton"
				class="btn btn-secondary toggle-tags-btn" onclick="toggleTags()">태그
				보기</button>
			<ul id="tagList">
				<%
				if (request.getAttribute("problemInfo") != null) {
					List<Map<String, Object>> tags = (List<Map<String, Object>>) ((Map<String, Object>) request
					.getAttribute("problemInfo")).get("tags");
					if (tags != null) {
						for (Map<String, Object> tag : tags) {
				%>
				<li><%=tag.get("tagName")%></li>
				<%
				}
				}
				}
				%>
			</ul>
		</div>

		<!-- 문제 풀이 및 다시 뽑기 버튼 -->
		<div class="center">
			<!-- 제한시간 설정 -->
			<label for="limitTime"><strong>제한시간(분):</strong></label> <input
				type="number" id="limitTime" name="limitTime" min="1" value="30"
				required style="width: 60px; text-align: center; margin-left: 5px;">
			<form action="/time" method="get" style="display: inline;">
				<input type="hidden" name="problemId"
					value="<%=request.getAttribute("problemId")%>"> <input
					type="hidden" id="hiddenLimitTime" name="limitTime">
				<button type="button" class="btn btn-primary"
					onclick="setLimitTimeAndOpenChild()">문제 풀기</button>
			</form>
			<form action="/problem" method="get" style="display: inline;">
				<button type="submit" class="btn btn-warning">다시 뽑기</button>
			</form>
		</div>
	</div>
</body>
</html>