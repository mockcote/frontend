<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>마이페이지</title>
    <script src="/js/authFetch.js"></script>
    <script>
        const BASE_URL = "${gatewayUrl}";
        const handle = "${cookie.handle.value}";

        // 유저 통계 가져오기
        async function fetchUserStats() {
            try {
                const userStats = await authFetch(BASE_URL+"/stats/user?handle="+handle).then((res) => res.json());
                const tableBody = document.getElementById('user-stats-body');
                tableBody.innerHTML = ''; // 기존 내용 초기화

                const row = document.createElement('tr');
                row.innerHTML = '<td>' + userStats.totalProblems + '</td><td>'
                                + userStats.solvedProblems + '</td><td>'
                                + userStats.failedProblems + '</td><td>'
                                + userStats.successRate + '%</td><td>'
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
                    row.innerHTML = '<td>' + stat.tagName + '</td><td>' + stat.solvedCount + '</td>';
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
                    row.innerHTML = '<td>' + stat.levelName + '</td><td>' + stat.solved + '</td>';
                    tableBody.appendChild(row);
                });
            } catch (error) {
                console.error('레벨별 문제 수 가져오기 실패:', error);
            }
        }

        // 페이지 로드 시 데이터 가져오기
        window.onload = function () {
            fetchUserStats()
            fetchTagStats();
            fetchLevelStats();
        };
    </script>
</head>
<body>
    <h1>마이페이지</h1>

    <h2>사용자 통계</h2>
    <table border="1">
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
    <table border="1">
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
    <table border="1">
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
