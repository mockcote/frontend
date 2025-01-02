<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, java.util.Map" %>
<jsp:include page="header.jsp" />
<html>
<head>
    <title>문제 랭킹</title>
    <style>
        /* 기존 스타일 유지 또는 추가 */
        body {
            font-family: Arial, sans-serif;
            background-color: #f9f9f9;
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
        table {
            width: 100%;
            border-collapse: collapse;
        }
        th, td {
            border: 1px solid #ddd;
            padding: 10px;
            text-align: center;
        }
        th {
            background-color: #f2f2f2;
        }
        .btn {
            padding: 10px 20px;
            font-size: 16px;
            background-color: #007bff;
            color: #ffffff;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            margin-top: 20px;
        }
        .btn:hover {
            background-color: #0056b3;
        }
    </style>
    <script>
        // handle과 problemId를 JavaScript 변수로 설정
        const handle = "${cookie.handle.value}";
        const problemId = <%= request.getAttribute("problemId") %>;

        async function checkAndProceedRanking(event) {
            event.preventDefault(); // 폼의 기본 제출 동작을 막음

            try {
            	console.log("handle: ",handle);
            	console.log("problemId: ", problemId);
            	
                const response = await fetch(BASE_URL+"/problems/problem/has-solved", {
                    method: "POST",
                    headers: {
                        "Content-Type": "application/json"
                    },
                    body: JSON.stringify({ handle, problemId })
                });
                
                

                if (response.ok) {
                    const data = await response.json();
                    console.log("Response data:", data);
                    if (data.hasSolved) {
                        alert("이미 백준에서 문제를 풀었습니다. 따라서 이 웹사이트에서는 풀 수 없습니다.");
                    } else {
                        // 제한시간 설정 및 리다이렉트
                        const limitTime = prompt("제한시간(분)을 입력해주세요:", "30");
                        if (limitTime && !isNaN(limitTime) && parseInt(limitTime) > 0) {
                        	// 새 창으로 열기
                            const url = `/time?problemId=${problemId}&limitTime=`+limitTime;
                            console.log("새 창 열기 URL:", url); // URL 확인용 로그
                            
                            const childWindow = window.open(
                                url, // 자식 창 URL
                                "childWindow",
                                "width=800,height=600" // 창 크기 설정
                            );
                        } else {
                            alert("올바른 제한시간을 입력해주세요.");
                        }
                    }
                } else {
                    const errorText = await response.text();
                    console.error("API error response:", errorText);
                    alert(`문제 해결 여부를 확인하는 데 실패했습니다. 상태 코드: ${response.status}, 메시지: ${errorText}`);
                }
            } catch (error) {
                console.error("Error:", error);
                alert("서버 오류가 발생했습니다.");
            }
        }
        
     // 자식 창 상태 변경 메시지 처리
        window.addEventListener("message", (event) => {
            if (event.origin !== window.location.origin) return; // 도메인 확인

            switch (event.data) {
                case 'taskComplete':
                case 'stop':
                    window.location.href = `/problem/rank?problemId=<%=request.getAttribute("problemId")%>`;
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
        <h1>문제 ID: <%= request.getAttribute("problemId") %> 랭킹</h1>
        <table>
            <thead>
                <tr>
                    <th>랭킹</th>
                    <th>사용자</th>
                </tr>
            </thead>
            <tbody>
                <% 
                    List<Map<String, Object>> ranks = (List<Map<String, Object>>) request.getAttribute("ranks");
                    if (ranks != null) {
                        for (Map<String, Object> rank : ranks) {
                %>
                <tr>
                    <td><%= rank.get("rank") %></td>
                    <td><%= rank.get("handle") %></td>
                </tr>
                <% 
                        }
                    } else { 
                %>
                <tr>
                    <td colspan="2">랭킹 정보가 없습니다.</td>
                </tr>
                <% } %>
            </tbody>
        </table>
        <button class="btn" onclick="checkAndProceedRanking(event)">문제 풀기</button>
        <a href="/problem/list" class="btn" style="background-color: #6c757d; margin-left: 10px;">문제 목록으로 돌아가기</a>
    </div>
</body>
</html>
