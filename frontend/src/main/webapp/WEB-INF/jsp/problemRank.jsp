<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, java.util.Map" %>
<html>
<head>
    <title>문제 랭킹</title>
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
        <a href="/problem/list" class="btn">문제 목록으로 돌아가기</a>
    </div>
</body>
</html>
