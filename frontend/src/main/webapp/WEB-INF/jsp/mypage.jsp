<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<jsp:include page="header.jsp" />
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>마이페이지</title>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500;700&display=swap" rel="stylesheet">
    <script src="/js/authFetch.js"></script>
    <style>
        body {
            font-family: 'Roboto', sans-serif;
            background-color: #f4f6f8;
            margin: 0;
            padding: 20px;
            color: #333;
        }
        h1 {
            text-align: center;
            color: #2c3e50;
            margin-bottom: 40px;
        }
        h2 {
            color: #34495e;
            margin-top: 30px;
            margin-bottom: 15px;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 30px;
            background-color: #fff;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }
        th, td {
            padding: 12px 15px;
            text-align: center;
        }
        th {
            background-color: #3498db;
            color: #fff;
            font-weight: 500;
            text-transform: uppercase;
            letter-spacing: 0.03em;
        }
        tr:nth-child(even) {
            background-color: #f9fafb;
        }
        tr:hover {
            background-color: #f1f3f5;
        }
        @media (max-width: 768px) {
            table, thead, tbody, th, td, tr {
                display: block;
            }
            th {
                position: absolute;
                top: -9999px;
                left: -9999px;
            }
            tr {
                margin-bottom: 15px;
            }
            td {
                padding-left: 50%;
                position: relative;
            }
            td::before {
                content: attr(data-label);
                position: absolute;
                left: 15px;
                width: 45%;
                padding-right: 10px;
                white-space: nowrap;
                font-weight: 500;
                text-align: left;
                color: #7f8c8d;
            }
        }
        .btn-detailed-stats {
            background-color: #3498db;
            color: #fff;
            padding: 10px 20px;
            font-size: 16px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            transition: background-color 0.3s ease;
            text-transform: uppercase;
            font-weight: 500;
        }

        .btn-detailed-stats:hover {
            background-color: #2980b9;
        }

        .btn-detailed-stats:active {
            background-color: #1c6396;
            box-shadow: inset 0 3px 5px rgba(0, 0, 0, 0.2);
        }
    </style>
    <script>
        const handle = "${cookie.handle.value}";
        let currentPage = 0; // 현재 페이지
        let totalPages = 1; // 전체 페이지 수

        // 유저 통계 가져오기
        async function fetchUserStats() {
            try {
                const userStats = await authFetch(BASE_URL+"/stats/user?handle="+handle).then((res) => res.json());
                const tableBody = document.getElementById('user-stats-body');
                tableBody.innerHTML = ''; // 기존 내용 초기화

                const row = document.createElement('tr');
                row.innerHTML = '<td data-label="시도한 문제 횟수">' + userStats.totalProblems + '</td><td data-label="성공한 문제 횟수">'
                                + userStats.solvedProblems + '</td><td data-label="실패한 문제 횟수">'
                                + userStats.failedProblems + '</td><td data-label="성공률">'
                                + userStats.successRate + '%</td><td data-label="걸린 시간 평균">'
                                + userStats.averageDuration + '초</td>';
                tableBody.appendChild(row);
            } catch (error) {
                console.error('유저 통계 가져오기 실패:', error);
            }
        }

        // 유저 히스토리 가져오기
        async function fetchUserHistory() {
            try {
                const response = await authFetch(BASE_URL + "/stats/history?handle=" + handle + "&page=" + currentPage);
                const data = await response.json();
                const userHistory = data.content;
                totalPages = data.totalPages; // 전체 페이지 수 업데이트

                const historyBody = document.getElementById('user-history-body');
                historyBody.innerHTML = ''; // 기존 내용 초기화

                userHistory.forEach(history => {
                    const row = document.createElement('tr');
                    const startTime = new Date(history.startTime);
                    const formattedStartTime = startTime.getFullYear().toString() + "-"
                        + (startTime.getMonth() + 1).toString().padStart(2, "0") + "-"
                        + startTime.getDate().toString().padStart(2, "0") + " "
                        + startTime.getHours().toString().padStart(2, "0") + ":"
                        + startTime.getMinutes().toString().padStart(2, "0");

                    row.innerHTML =
                        '<td data-label="문제 번호"><a href="/problem/rank?problemId='+history.problemId+'">'+ history.problemId
                        + '</a></td><td data-label="풀이 상태">' + history.status
                        + '</td><td data-label="소요 시간">' + history.duration
                        + '초</td><td data-label="사용 언어">' + history.language
                        + '</td><td data-label="시작 시간">' + formattedStartTime
                        + '</td>';
                    historyBody.appendChild(row);
                });

                createPaginationButtons(); // 페이지네이션 버튼 생성
            } catch (error) {
                console.error('유저 히스토리 가져오기 실패:', error);
            }
        }

        // 페이지네이션 버튼
        function createPaginationButtons() {
            const paginationDiv = document.getElementById('pagination');

            // 이전/다음 버튼 참조
            const prevButton = document.getElementById('prev-page');
            const nextButton = document.getElementById('next-page');

            // 이전 버튼 활성화/비활성화
            prevButton.disabled = currentPage === 0;
            prevButton.onclick = function () {
                if (currentPage > 0) {
                    currentPage--;
                    fetchUserHistory();
                }
            };

            // 다음 버튼 활성화/비활성화
            nextButton.disabled = currentPage === totalPages - 1;
            nextButton.onclick = function () {
                if (currentPage < totalPages - 1) {
                    currentPage++;
                    fetchUserHistory();
                }
            };

            // 페이지 번호 버튼 생성 (기존 로직 유지)
            const pageButtons = document.createElement('span');
            pageButtons.style.margin = '0 10px';
            paginationDiv.innerHTML = ''; // 기존 버튼 초기화
            paginationDiv.appendChild(prevButton);

            for (let i = 0; i < totalPages; i++) {
                const button = document.createElement('button');
                button.textContent = i + 1;
                button.style.margin = '0 5px';
                button.disabled = i === currentPage;

                button.onclick = function () {
                    currentPage = i;
                    fetchUserHistory();
                };

                pageButtons.appendChild(button);
            }

            paginationDiv.appendChild(pageButtons);
            paginationDiv.appendChild(nextButton);
        }

        // 상세 통계 페이지 이동
        function goToDetailedStats() {
            window.location.href = "/stat?handle=" + handle;
        }

        // 페이지 로드 시 데이터 가져오기
        window.onload = function () {
            fetchUserStats();
            fetchUserHistory();
        };
    </script>
</head>
<body>
    <h1>마이페이지</h1>

    <h2>사용자 통계</h2>
    <table>
        <thead>
            <tr>
                <th>시도한 문제 횟수</th>
                <th>성공한 문제 횟수</th>
                <th>실패한 문제 횟수</th>
                <th>성공률</th>
                <th>걸린 시간 평균</th>
            </tr>
        </thead>
        <tbody id="user-stats-body">
            <!-- 사용자 통계 데이터가 여기에 추가됨 -->
        </tbody>
    </table>

    <div style="text-align: center; margin-bottom: 30px;">
        <button class="btn-detailed-stats" onclick="goToDetailedStats()">상세 통계 보기</button>
    </div>

    <h2>사용자 히스토리</h2>
    <table>
        <thead>
            <tr>
                <th>문제 번호</th>
                <th>풀이 상태</th>
                <th>소요 시간</th>
                <th>사용 언어</th>
                <th>제출 시각</th>
            </tr>
        </thead>
        <tbody id="user-history-body">
            <!-- 유저 히스토리 데이터가 여기에 추가됨 -->
        </tbody>
    </table>
    <div id="pagination" style="text-align: center; margin-top: 20px;">
        <button id="prev-page" class="btn btn-secondary" disabled>이전</button>
        <!-- 페이지 번호 버튼이 동적으로 추가됩니다 -->
        <button id="next-page" class="btn btn-secondary" disabled>다음</button>
    </div>
</body>
</html>
