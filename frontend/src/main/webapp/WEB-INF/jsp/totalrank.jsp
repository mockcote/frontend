<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.mockcote.model.UserRanking" %>
<html>
<head>
    <title>전체 사용자 랭킹</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            background-color: #f9f9f9;
            color: #333;
        }
        .container {
            max-width: 960px;
            margin: 20px auto;
            padding: 20px;
            background: #ffffff;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }
        h1 {
            text-align: center;
            color: #4CAF50;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin: 20px 0;
        }
        th, td {
            border: 1px solid #ddd;
            padding: 10px;
            text-align: center;
        }
        th {
            background-color: #4CAF50;
            color: white;
        }
        td a {
            color: #4CAF50;
            text-decoration: none;
            font-weight: bold;
        }
        td a:hover {
            text-decoration: underline;
        }
        .pagination {
            text-align: center;
            margin-top: 20px;
        }
        .pagination a {
            margin: 0 5px;
            padding: 10px 15px;
            background: #4CAF50;
            color: white;
            text-decoration: none;
            border-radius: 5px;
        }
        .pagination a:hover {
            background: #45a049;
        }
        .pagination a.disabled {
            background: #ccc;
            pointer-events: none;
        }
    </style>
</head>
<body>
<div class="container">
    <h1>전체 사용자 랭킹</h1>

    <% if (request.getAttribute("error") != null) { %>
        <p style="color: red; text-align: center;">
            <%= request.getAttribute("error") %>
        </p>
    <% } %>

    <table>
        <thead>
        <tr>
            <th>랭킹</th>
            <th>사용자 핸들</th>
            <th>점수</th>
        </tr>
        </thead>
        <tbody>
        <% 
        List<com.mockcote.model.UserRanking> rankings = 
            (List<com.mockcote.model.UserRanking>) request.getAttribute("rankings");
        if (rankings != null && !rankings.isEmpty()) {
            for (com.mockcote.model.UserRanking user : rankings) { 
        %>
        <tr>
            <td><%= user.getRanking() %></td>
            <td><a href="/stat?handle=<%= user.getHandle() %>"><%= user.getHandle() %></a></td>
            <td><%= user.getScore() %></td>
        </tr>
        <% 
            }
        } else { 
        %>
        <tr>
            <td colspan="3">랭킹 정보가 없습니다.</td>
        </tr>
        <% } %>
        </tbody>
    </table>

    <!-- 페이지네이션 -->
    <% 
    int totalPages = (int) request.getAttribute("totalPages");
    int pageNumber = (int) request.getAttribute("pageNumber");
    if (totalPages > 1) { 
    %>
    <div class="pagination">
        <% if (pageNumber > 0) { %>
            <a href="/rank/total?page=<%= pageNumber - 1 %>&size=20">이전</a>
        <% } else { %>
            <a class="disabled">이전</a>
        <% } %>
        <span>Page <%= pageNumber + 1 %> of <%= totalPages %></span>
        <% if (pageNumber < totalPages - 1) { %>
            <a href="/rank/total?page=<%= pageNumber + 1 %>&size=20">다음</a>
        <% } else { %>
            <a class="disabled">다음</a>
        <% } %>
    </div>
    <% } %>
</div>
</body>
</html>
