<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, java.util.Map" %>
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
    </script>
</head>
<body>
    <div class="container">
        <h1>문제 뽑기 결과</h1>

        <!-- 서버에서 전달된 메시지 표시 -->
        <p><%= request.getAttribute("problemMessage") %></p>

        <!-- 문제 정보 표시 -->
        <div class="problem-details">
            <p><strong>문제 번호:</strong> <%= request.getAttribute("problemId") %></p>
            <p><strong>문제 제목:</strong> <%= request.getAttribute("problemInfo") != null 
                ? ((Map<String, Object>) request.getAttribute("problemInfo")).get("title") 
                : "N/A" %></p>
            <p><strong>난이도:</strong> <%= request.getAttribute("problemInfo") != null 
                ? ((Map<String, Object>) request.getAttribute("problemInfo")).get("difficulty") 
                : "N/A" %></p>
            <p><strong>제출한 사용자 수:</strong> <%= request.getAttribute("problemInfo") != null 
                ? ((Map<String, Object>) request.getAttribute("problemInfo")).get("acceptableUserCount") 
                : "N/A" %></p>
            <button id="toggleTagsButton" class="btn btn-secondary toggle-tags-btn" onclick="toggleTags()">태그 보기</button>
            <ul id="tagList">
                <% 
                    if (request.getAttribute("problemInfo") != null) {
                        List<Map<String, Object>> tags = (List<Map<String, Object>>) ((Map<String, Object>) request.getAttribute("problemInfo")).get("tags");
                        if (tags != null) {
                            for (Map<String, Object> tag : tags) {
                %>
                    <li><%= tag.get("tagName") %></li>
                <%
                            }
                        }
                    }
                %>
            </ul>
        </div>

        <!-- 문제 풀이 페이지로 이동 버튼 -->
        <div class="center">
            <form action="/problem/solve" method="get">
                <input type="hidden" name="problemId" value="<%= request.getAttribute("problemId") %>">
                <button type="submit" class="btn btn-primary">문제 풀기</button>
            </form>
        </div>
    </div>
</body>
</html>
