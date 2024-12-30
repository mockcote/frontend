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
    </style>
    <script>
        const handle = "${cookie.handle.value}";

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

        // 태그별 문제 수 가져오기
        async function fetchTagStats() {
            try {
                const tagStats = await authFetch(BASE_URL+"/stats/tags?handle="+handle).then((res) => res.json());
                const tableBody = document.getElementById('tag-stats-body');
                tableBody.innerHTML = ''; // 기존 내용 초기화

                tagStats.forEach(stat => {
                    const row = document.createElement('tr');
                    row.innerHTML = '<td data-label="태그">' + stat.tagName + '</td><td data-label="풀이 수">' + stat.solvedCount + '</td>';
                    tableBody.appendChild(row);
                });
            } catch (error) {
                console.error('태그별 문제 수 가져오기 실패:', error);
            }
        }

        // 레벨별 문제 수 가져오기
        async function fetchLevelStats() {
            try {
                const levelStats = await authFetch(BASE_URL+"/stats/levels?handle="+handle).then((res) => res.json());
                const tableBody = document.getElementById('level-stats-body');
                tableBody.innerHTML = ''; // 기존 내용 초기화

                levelStats.forEach(stat => {
                    const row = document.createElement('tr');
                    row.innerHTML = '<td data-label="레벨">' + stat.levelName + '</td><td data-label="풀이 수">' + stat.solved + '</td>';
                    tableBody.appendChild(row);
                });
            } catch (error) {
                console.error('레벨별 문제 수 가져오기 실패:', error);
            }
        }

        // 페이지 로드 시 데이터 가져오기
        window.onload = function () {
            fetchUserStats();
            fetchTagStats();
            fetchLevelStats();
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

    <h2>태그별 문제 풀이 통계</h2>
    <table>
        <thead>
            <tr>
                <th>태그</th>
                <th>풀이 수</th>
            </tr>
        </thead>
        <tbody id="tag-stats-body">
            <!-- 태그별 문제 수 데이터가 여기에 추가됨 -->
        </tbody>
    </table>

    <h2>레벨별 문제 풀이 통계</h2>
    <table>
        <thead>
            <tr>
                <th>레벨</th>
                <th>풀이 수</th>
            </tr>
        </thead>
        <tbody id="level-stats-body">
            <!-- 레벨별 문제 수 데이터가 여기에 추가됨 -->
        </tbody>
    </table>
</body>
</html>
