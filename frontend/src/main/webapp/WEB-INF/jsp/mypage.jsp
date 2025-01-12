<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:include page="header.jsp" />
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>마이페이지</title>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500;700&display=swap" rel="stylesheet">
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

        // 상세 통계 페이지 이동
        function goToDetailedStats() {
            window.location.href = "/stat?handle=" + handle;
        }
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
        <tbody>
            <tr>
                <td>${userStats.totalProblems}</td>
                <td>${userStats.solvedProblems}</td>
                <td>${userStats.failedProblems}</td>
                <td>${userStats.successRate}%</td>
                <td>${userStats.averageDuration}초</td>
            </tr>
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
            <c:forEach var="history" items="${userHistory.content}">
                <tr>
                    <td><a href="/problem/rank?problemId=${history.problemId}">${history.problemId}</a></td>
                    <td>${history.status}</td>
                    <td>${history.duration}초</td>
                    <td>${history.language}</td>
                    <td>
                        <fmt:formatDate value="${history.startTime}" pattern="yyyy-MM-dd HH:mm" />
                    </td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
    <c:if test="${totalPages > 0}">
        <div id="pagination" style="text-align: center; margin-top: 20px;">
            <!-- 이전 버튼 -->
            <c:choose>
                <c:when test="${currentPage > 0}">
                    <a href="/mypage?page=${currentPage - 1}" class="btn btn-secondary">이전</a>
                </c:when>
                <c:otherwise>
                    <button class="btn btn-secondary" disabled>이전</button>
                </c:otherwise>
            </c:choose>

            <!-- 페이지 번호 버튼 -->
            <c:forEach var="i" begin="0" end="${totalPages - 1}">
                <c:choose>
                    <c:when test="${i == currentPage}">
                        <button class="btn btn-primary" disabled>${i + 1}</button>
                    </c:when>
                    <c:otherwise>
                        <a href="/mypage?page=${i}" class="btn btn-secondary">${i + 1}</a>
                    </c:otherwise>
                </c:choose>
            </c:forEach>

            <!-- 다음 버튼 -->
            <c:choose>
                <c:when test="${currentPage < totalPages - 1}">
                    <a href="/mypage?page=${currentPage + 1}" class="btn btn-secondary">다음</a>
                </c:when>
                <c:otherwise>
                    <button class="btn btn-secondary" disabled>다음</button>
                </c:otherwise>
            </c:choose>
        </div>
    </c:if>
</body>
</html>
