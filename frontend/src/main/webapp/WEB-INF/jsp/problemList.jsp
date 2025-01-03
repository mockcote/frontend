<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, java.util.Map" %>
<jsp:include page="header.jsp" />
<html>
<head>
    <title>문제 목록</title>
    <style>
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

        .search-form {
            display: flex;
            justify-content: space-between;
            margin-bottom: 20px;
        }

        .search-form input[type="text"] {
            flex: 1;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
            margin-right: 10px;
        }

        .search-form button {
            padding: 10px 20px;
            background-color: #007bff;
            color: #fff;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }

        .search-form button:hover {
            background-color: #0056b3;
        }

        .problem-table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 20px;
        }

        .problem-table th, .problem-table td {
            border: 1px solid #ddd;
            padding: 10px;
            text-align: center;
        }

        .problem-table th {
            background-color: #f2f2f2;
        }

        .btn {
            padding: 8px 16px;
            font-size: 14px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            margin: 5px;
        }

        .btn-primary {
            background-color: #007bff;
            color: #ffffff;
        }

        .btn-primary:hover {
            background-color: #0056b3;
        }

        .pagination {
            text-align: center;
            margin-top: 20px;
            display: flex;
            justify-content: center;
            gap: 10px;
        }

        .pagination a {
            text-decoration: none;
            padding: 8px 12px;
            border: 1px solid #ddd;
            border-radius: 4px;
            color: #007bff;
            transition: background-color 0.3s;
        }

        .pagination a:hover {
            background-color: #f0f0f0;
        }

        .pagination .current {
            background-color: #007bff;
            color: #fff;
            pointer-events: none;
        }

    </style>
</head>
<body>
    <div class="container">
        <h1>문제 목록</h1>

        <!-- 검색 폼 -->
        <form class="search-form" action="/problem/list" method="get">
            <input type="text" name="search" placeholder="문제 번호로 검색" value="<%= request.getParameter("search") != null ? request.getParameter("search") : "" %>">
            <button type="submit">검색</button>
        </form>

        <!-- 문제 목록 표시 -->
        <table class="problem-table">
            <thead>
                <tr>
                    <th>문제 ID</th>
                    <th>문제 제목</th>
                    <th>난이도</th>
                    <th>랭킹 보기</th>
                </tr>
            </thead>
            <tbody>
                <% 
                    Map<String, Object> problem = (Map<String, Object>) request.getAttribute("problem");
                    if (problem != null) {
                        // 단일 문제 표시
                %>
                <tr>
                    <td><%= problem.get("problemId") %></td>
                    <td><%= problem.get("title") %></td>
                    <td><%= problem.get("lavelName") %></td>
                    <td>
                        <form action="/problem/rank" method="get">
                            <input type="hidden" name="problemId" value="<%= problem.get("problemId") %>">
                            <button type="submit" class="btn btn-primary">랭킹 보기</button>
                        </form>
                    </td>
                </tr>
                <% 
                    } else {
                        List<Map<String, Object>> problems = (List<Map<String, Object>>) request.getAttribute("problems");
                        if (problems != null) {
                            for (Map<String, Object> p : problems) {
                %>
                <tr>
                    <td><%= p.get("problemId") %></td>
                    <td><%= p.get("title") %></td>
                    <td><%= p.get("levelName") %></td>
                    <td>
                        <form action="/problem/rank" method="get">
                            <input type="hidden" name="problemId" value="<%= p.get("problemId") %>">
                            <button type="submit" class="btn btn-primary">랭킹 보기</button>
                        </form>
                    </td>
                </tr>
                <% 
                            }
                        } else {
                %>
                <tr>
                    <td colspan="4">문제가 없습니다.</td>
                </tr>
                <% } } %>
            </tbody>
        </table>

        <!-- 페이지네이션 -->
        <% if (request.getAttribute("problem") == null) { %>
        <div class="pagination">
            <% 
                int currentPage = (int) request.getAttribute("currentPage");
                int totalPages = (int) request.getAttribute("totalPages");

                int startPage = Math.max(1, currentPage - 2);
                int endPage = Math.min(totalPages, currentPage + 2);

                if (currentPage > 1) {
            %>
            <a href="/problem/list?page=<%= currentPage - 1 %>&size=30&search=<%= request.getParameter("search") != null ? request.getParameter("search") : "" %>">이전</a>
            <% } %>

            <% for (int i = startPage; i <= endPage; i++) { %>
                <a href="/problem/list?page=<%= i %>&size=30&search=<%= request.getParameter("search") != null ? request.getParameter("search") : "" %>" class="<%= i == currentPage ? "current" : "" %>"><%= i %></a>
            <% } %>

            <% if (currentPage < totalPages) { %>
            <a href="/problem/list?page=<%= currentPage + 1 %>&size=30&search=<%= request.getParameter("search") != null ? request.getParameter("search") : "" %>">다음</a>
            <% } %>
        </div>
        <% } %>
    </div>
</body>
</html>
