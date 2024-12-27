<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, java.util.Map" %>

<html>
<head>
    <title>Problem Pick Page</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            line-height: 1.6;
            margin: 20px;
            padding: 0;
            background-color: #f7f7f7;
        }
        h1 {
            color: #333;
        }
        fieldset {
            border: 1px solid #ccc;
            padding: 10px;
            margin-bottom: 15px;
            background-color: #fff;
        }
        legend {
            font-weight: bold;
            color: #555;
        }
        label {
            display: block;
            margin: 5px 0;
        }
        input[type="number"], input[type="text"] {
            width: 80%;
            padding: 5px;
            margin-top: 5px;
            margin-bottom: 15px;
            border: 1px solid #ccc;
            border-radius: 4px;
        }
        button {
            padding: 10px 20px;
            background-color: #007bff;
            color: #fff;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }
        button:hover {
            background-color: #0056b3;
        }
        .tag-search {
            margin-bottom: 15px;
        }
        .tag-list {
            max-height: 150px;
            overflow-y: auto;
            border: 1px solid #ddd;
            background-color: #fff;
            padding: 10px;
            border-radius: 4px;
        }
        #condition-fields {
            display: none;
        }
    </style>
    <script>
        function toggleConditionFields(option) {
            const conditionFields = document.getElementById("condition-fields");
            conditionFields.style.display = option === "query" ? "block" : "none";
        }

        function filterTags(inputId, listId) {
            const filter = document.getElementById(inputId).value.toLowerCase();
            const items = document.getElementById(listId).getElementsByTagName("label");

            for (let item of items) {
                const text = item.innerText.toLowerCase();
                item.style.display = text.includes(filter) ? "block" : "none";
            }
        }

        function setDefaultValues() {
            const minDifficulty = document.getElementById("minDifficulty");
            const maxDifficulty = document.getElementById("maxDifficulty");
            const minAcceptableUserCount = document.getElementById("minAcceptableUserCount");
            const maxAcceptableUserCount = document.getElementById("maxAcceptableUserCount");

            if (!minDifficulty.value) {
                minDifficulty.value = 1;
            }
            if (!maxDifficulty.value) {
                maxDifficulty.value = 20;
            }
            if (!minAcceptableUserCount.value) {
                minAcceptableUserCount.value = 0;
            }
            if (!maxAcceptableUserCount.value) {
                maxAcceptableUserCount.value = 10000000;
            }
        }
    </script>
</head>
<body>
    <h1>문제 뽑기</h1>

    <!-- 서버에서 전달해 준 메시지(문제 정보) 표시 -->
    <p style="color: #333;">${problemMessage}</p>

    <!-- 문제 뽑기 폼 -->
    <form action="/problem/pick" method="post" onsubmit="setDefaultValues()">
        <label>
            <input type="radio" name="option" value="random-tag" checked onclick="toggleConditionFields('random-tag')"> 취약 태그 기반 문제 뽑기
        </label><br>
        <label>
            <input type="radio" name="option" value="query" onclick="toggleConditionFields('query')"> 조건 기반 문제 뽑기
        </label><br><br>

        <!-- 조건 기반 문제 뽑기에서만 표시될 영역 -->
        <div id="condition-fields">
            <label for="minDifficulty">최소 난이도:</label>
            <input type="number" id="minDifficulty" name="minDifficulty" min="1" max="30">
            <label for="maxDifficulty">최대 난이도:</label>
            <input type="number" id="maxDifficulty" name="maxDifficulty" min="1" max="30"><br><br>

            <!-- 문제 제출자 수 입력 -->
            <label for="minAcceptableUserCount">최소 제출자 수:</label>
            <input type="number" id="minAcceptableUserCount" name="minAcceptableUserCount">
            <label for="maxAcceptableUserCount">최대 제출자 수:</label>
            <input type="number" id="maxAcceptableUserCount" name="maxAcceptableUserCount"><br><br>

            <!-- 선호 태그 검색 및 선택 -->
            <fieldset>
                <legend>선호 태그 검색 및 선택</legend>
                <div class="tag-search">
                    <label for="searchDesiredTags">태그 검색:</label>
                    <input type="text" id="searchDesiredTags" onkeyup="filterTags('searchDesiredTags', 'desiredTagList')" placeholder="검색어 입력">
                </div>
                <div id="desiredTagList" class="tag-list">
                    <% 
                        List<Map<String, Object>> tags = (List<Map<String, Object>>) request.getAttribute("tags");
                        for (Map<String, Object> tag : tags) {
                    %>
                        <label>
                            <input type="checkbox" name="desiredTags" value="<%= tag.get("value") %>">
                            <%= tag.get("name") %>
                        </label>
                    <% 
                        }
                    %>
                </div>
            </fieldset>

            <!-- 비선호 태그 검색 및 선택 -->
            <fieldset>
                <legend>비선호 태그 검색 및 선택</legend>
                <div class="tag-search">
                    <label for="searchUndesiredTags">태그 검색:</label>
                    <input type="text" id="searchUndesiredTags" onkeyup="filterTags('searchUndesiredTags', 'undesiredTagList')" placeholder="검색어 입력">
                </div>
                <div id="undesiredTagList" class="tag-list">
                    <% 
                        for (Map<String, Object> tag : tags) {
                    %>
                        <label>
                            <input type="checkbox" name="undesiredTags" value="<%= tag.get("value") %>">
                            <%= tag.get("name") %>
                        </label>
                    <% 
                        }
                    %>
                </div>
            </fieldset><br>
        </div>

        <button type="submit">문제 뽑기</button>
    </form>
</body>
</html>
