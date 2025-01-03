<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, java.util.Map" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

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
        .btn-secondary {
            background-color: #6c757d;
            margin-left: 10px;
        }
        .btn-secondary:hover {
            background-color: #5a6268;
        }

        /* **추가: 로딩 모달 스타일링** */
        /* 로딩 모달 배경 */
        .loading-modal {
            display: none; /* 기본적으로 숨김 */
            position: fixed;
            z-index: 9999;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            overflow: hidden;
            background-color: rgba(0, 0, 0, 0.5); /* 반투명 배경 */
        }

        /* 로딩 모달 콘텐츠 */
        .loading-modal-content {
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            text-align: center;
            color: #fff;
        }

        /* 로딩 스피너 */
        .spinner {
            border: 8px solid #f3f3f3; /* Light grey */
            border-top: 8px solid #007bff; /* Blue */
            border-radius: 50%;
            width: 60px;
            height: 60px;
            animation: spin 1s linear infinite;
            margin: 0 auto 20px auto;
        }

        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }

        .loading-modal p {
            font-size: 18px;
            color: #fff;
        }
    </style>
    <script>
        // JSP 변수 설정
        const handle = "${cookie.handle.value}";
        const problemId = <%= request.getAttribute("problemId") != null ? request.getAttribute("problemId") : 0 %>;
        const BASE_URL = "${gatewayUrl}";

        // 로딩 모달 요소 가져오기
        document.addEventListener('DOMContentLoaded', (event) => {
            const loadingModal = document.getElementById("loadingModal");

            async function checkAndProceedRanking(event) {
                event.preventDefault(); // 폼의 기본 제출 동작을 막음

                try {
                    // 로딩 모달 표시
                    loadingModal.style.display = "block";

                    console.log("handle: ", handle);
                    console.log("problemId: ", problemId);
                    
                    const response = await fetch(BASE_URL + "/problems/problem/has-solved", {
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
                                // 리다이렉트
                                window.location.href = '/time?problemId=' + problemId + '&limitTime=' + limitTime;
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
                } finally {
                    // 로딩 모달 숨기기
                    loadingModal.style.display = "none";
                }
            }

            // 글로벌 함수 설정
            window.checkAndProceedRanking = checkAndProceedRanking;
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
                    if (ranks != null && !ranks.isEmpty()) {
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
        <a href="/problem/list" class="btn btn-secondary">문제 목록으로 돌아가기</a>
    </div>

    <!-- **추가: 로딩 모달 HTML** -->
    <div id="loadingModal" class="loading-modal">
        <div class="loading-modal-content">
            <div class="spinner"></div>
            <p>문제 풀이 여부 확인중...</p>
        </div>
    </div>
</body>
</html>
