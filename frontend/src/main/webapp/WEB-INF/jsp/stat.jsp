<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, java.util.Map" %>
<%@ page import="com.mockcote.util.LevelLoader" %>
<jsp:include page="header.jsp" />
<html>
<head>
    <title>사용자 통계</title>
    <script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
    <style>
        body {
            font-family: 'Roboto', Arial, sans-serif;
            margin: 0;
            background-color: #f4f7fc;
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
            font-size: 2.5em;
            margin-bottom: 20px;
        }
        .error {
            color: #ff4d4d;
            background: #ffe6e6;
            padding: 10px;
            border-radius: 5px;
            text-align: center;
            font-weight: bold;
        }
        .section {
            margin-bottom: 30px;
        }
        .section h2 {
            font-size: 1.8em;
            margin-bottom: 20px;
            border-bottom: 2px solid #eaeaea;
            padding-bottom: 10px;
        }
        .chart-container {
            margin: 0 auto;
            max-width: 600px;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        th, td {
            border: 1px solid #ddd;
            padding: 12px;
            text-align: center;
        }
        th {
            background-color: #4CAF50;
            color: white;
        }
        td {
            background-color: #f9f9f9;
        }
        td:hover {
            background-color: #f1f1f1;
        }
        .flex-container {
            display: flex;
            justify-content: space-between;
            flex-wrap: wrap;
        }
        .flex-item {
            flex: 1;
            margin: 10px;
            padding: 20px;
            background: #fdfdfd;
            border-radius: 10px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            text-align: center;
        }
    </style>
</head>
<body>
<div class="container">
    <h1>사용자 통계</h1>

    <!-- 오류 메시지 표시 -->
    <% if (request.getAttribute("error") != null) { %>
        <div class="error">
            <%= request.getAttribute("error") %>
        </div>
    <% } %>

    <!-- 사용자 랭킹 정보 표시 -->
    <% if (request.getAttribute("userRanking") != null) { 
        com.mockcote.model.UserRanking userRanking = 
            (com.mockcote.model.UserRanking) request.getAttribute("userRanking"); %>
        <div class="section">
            <h2>사용자 랭킹 정보</h2>
            <div class="flex-container">
                <div class="flex-item">
                    <strong>백준 handle</strong>
                    <p><%= userRanking.getHandle() %></p>
                </div>
                <div class="flex-item">
                    <strong>점수</strong>
                    <p><%= userRanking.getScore() == 0 ? "점수 없음" : userRanking.getScore() %></p>
                </div>
                <div class="flex-item">
                    <strong>랭킹</strong>
                    <p><%= userRanking.getRanking() %> 위</p>
                </div>
            </div>
        </div>
    <% } %>

    <!-- 태그별 푼 문제 수 표시 -->
    <% if (request.getAttribute("tagStats") != null) { 
        List<Map<String, Object>> tagStats = 
            (List<Map<String, Object>>) request.getAttribute("tagStats"); %>
        <div class="section">
            <h2>태그별 푼 문제 수</h2>
            <div class="chart-container">
                <div id="tag-chart"></div>
            </div>
            <table>
                <tr>
                    <th>태그 이름</th>
                    <th>푼 문제 수</th>
                </tr>
                <% for (Map<String, Object> tag : tagStats) { %>
                <tr>
                    <td><%= tag.get("tagName") %></td>
                    <td><%= tag.get("solvedCount") %></td>
                </tr>
                <% } %>
            </table>
            <script type="text/javascript">
                google.charts.load('current', {'packages': ['corechart']});
                google.charts.setOnLoadCallback(drawTagChart);
                function drawTagChart() {
                    var data = google.visualization.arrayToDataTable([
                        ['Tag', 'Solved Count'],
                        <% for (Map<String, Object> tag : tagStats) { %>
                        ['<%= tag.get("tagName") %>', <%= tag.get("solvedCount") %>],
                        <% } %>
                    ]);
                    var options = {
                        title: '태그별 문제 풀이 통계',
                        pieHole: 0.4,
                        colors: ['#FF5733', '#33FF57', '#3357FF', '#FF33A1', '#A1FF33']
                    };
                    var chart = new google.visualization.PieChart(document.getElementById('tag-chart'));
                    chart.draw(data, options);
                }
            </script>
        </div>
    <% } %>

    <!-- 난이도별 푼 문제 수 표시 -->
    <% if (request.getAttribute("levelStats") != null) { 
        List<Map<String, Object>> levelStats = 
            (List<Map<String, Object>>) request.getAttribute("levelStats"); %>
        <div class="section">
            <h2>난이도별 푼 문제 수</h2>
            <div class="chart-container">
                <div id="level-chart"></div>
            </div>
            <table>
                <tr>
                    <th>난이도</th>
                    <th>푼 문제 수</th>
                </tr>
                <% for (Map<String, Object> level : levelStats) { 
                    int levelValue = (int) level.get("level");
                    int solvedCount = (int) level.get("solved"); %>
                <tr>
                    <td><%= LevelLoader.getLevelName(levelValue) %></td>
                    <td><%= solvedCount %></td>
                </tr>
                <% } %>
            </table>
            <script type="text/javascript">
                google.charts.load('current', {'packages': ['bar']});
                google.charts.setOnLoadCallback(drawLevelChart);
                function drawLevelChart() {
                    var data = google.visualization.arrayToDataTable([
                        ['Level', 'Solved Count'],
                        <% for (Map<String, Object> level : levelStats) { 
                            int levelValue = (int) level.get("level");
                            int solvedCount = (int) level.get("solved"); %>
                        ['<%= LevelLoader.getLevelName(levelValue) %>', <%= solvedCount %>],
                        <% } %>
                    ]);
                    var options = {
                        chart: {
                            title: '난이도별 문제 풀이 통계',
                        },
                        colors: ['#33A1FF']
                    };
                    var chart = new google.charts.Bar(document.getElementById('level-chart'));
                    chart.draw(data, google.charts.Bar.convertOptions(options));
                }
            </script>
        </div>
    <% } %>
</div>
</body>
</html>
