<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, java.util.Map" %>
<jsp:include page="header.jsp" />
<html>
<head>
    <title>문제 뽑기</title>
    <style>
        /* 기존 스타일 유지 또는 개선 */
        body {
            font-family: Arial, sans-serif;
            line-height: 1.6;
            margin: 0;
            padding: 0;
            background-color: #f9f9f9;
        }
        header {
            background-color: #007bff;
            color: #fff;
            padding: 20px;
            text-align: center;
        }
        .container {
            max-width: 800px;
            margin: 20px auto;
            padding: 20px;
            background-color: #fff;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }
        h1 {
            color: #333;
            margin-bottom: 20px;
        }
        label {
            display: block;
            margin: 10px 0 5px;
        }
        input[type="number"], input[type="text"], button {
            width: 100%;
            padding: 10px;
            margin: 5px 0;
            border: 1px solid #ccc;
            border-radius: 4px;
            box-sizing: border-box;
        }
        button {
            background-color: #007bff;
            color: #fff;
            border: none;
            cursor: pointer;
            transition: background-color 0.3s;
        }
        button:hover {
            background-color: #0056b3;
        }
        fieldset {
            border: none;
            margin-bottom: 20px;
        }
        legend {
            font-weight: bold;
            margin-bottom: 10px;
        }
        .tag-search input {
            margin-bottom: 10px;
        }
        .tag-list {
            max-height: 150px;
            overflow-y: auto;
            border: 1px solid #ddd;
            background-color: #f7f7f7;
            padding: 10px;
            border-radius: 4px;
        }
        .difficulty-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 10px;
        }
        .difficulty-table th, .difficulty-table td {
            border: 1px solid #ddd;
            padding: 8px;
            text-align: center;
        }
        .difficulty-table th {
            background-color: #f2f2f2;
        }
        .toggle-button {
            display: block;
            margin: 10px auto;
            text-align: center;
            cursor: pointer;
            color: #007bff;
        }
        .toggle-button:hover {
            text-decoration: underline;
        }

        /* **추가: 로딩 모달 스타일링** */
        /* 로딩 모달 배경 */
        .loading-modal {
            display: none; /* 기본적으로 숨김 */
            position: fixed;
            z-index: 9999;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            overflow: hidden;
            background-color: rgba(0, 0, 0, 0.5); /* 반투명 배경 */
        }

        /* 로딩 모달 콘텐츠 */
        .loading-modal-content {
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            text-align: center;
            color: #fff;
        }

        /* 로딩 스피너 */
        .spinner {
            border: 8px solid #f3f3f3; /* Light grey */
            border-top: 8px solid #007bff; /* Blue */
            border-radius: 50%;
            width: 60px;
            height: 60px;
            animation: spin 1s linear infinite;
            margin: 0 auto 20px auto;
        }

        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }
    </style>
    <script>
        function toggleDifficultyTable() {
            const table = document.getElementById("difficultyTable");
            const toggleButton = document.getElementById("toggleDifficultyButton");

            if (table.style.display === "none") {
                table.style.display = "table";
                toggleButton.textContent = "난이도표 숨기기";
            } else {
                table.style.display = "none";
                toggleButton.textContent = "난이도표 보기";
            }
        }

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

        // **추가: 로딩 모달 표시 함수**
        function showLoadingModal() {
            document.getElementById('loadingModal').style.display = 'block';
        }

        // **추가: 폼 제출 시 로딩 모달 표시**
        window.addEventListener('DOMContentLoaded', (event) => {
            const form = document.getElementById('problemPickForm');
            form.addEventListener('submit', function() {
                showLoadingModal();
            });
        });

        // setDefaultValues 함수는 기본 값이 HTML에서 설정되므로 필요 없을 수 있습니다.
        function setDefaultValues() {
            // 필요 시 추가 로직
        }
    </script>
</head>
<body>
    <header>
        <h1>문제 뽑기</h1>
    </header>
    <div class="container">
        <p style="color: #555;">${problemMessage}</p>

        <c:if test="${not empty cookie.handle}">
            <p>현재 사용자: ${cookie.handle.value}</p>
        </c:if>

        <!-- **추가: 로딩 모달 HTML** -->
        <div id="loadingModal" class="loading-modal">
            <div class="loading-modal-content">
                <div class="spinner"></div>
                <p>문제를 뽑는 중입니다. 잠시만 기다려주세요...</p>
            </div>
        </div>

        <form id="problemPickForm" action="/problem/pick" method="post">
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />

            <label>
                <input type="radio" name="option" value="random-tag" checked onclick="toggleConditionFields('random-tag')"> 취약 태그 기반 문제 뽑기
            </label>
            <label>
                <input type="radio" name="option" value="query" onclick="toggleConditionFields('query')"> 조건 기반 문제 뽑기
            </label>

            <div id="condition-fields" style="display: none;">
                <fieldset>
                    <legend>조건 설정</legend>
                    <label for="minDifficulty">최소 난이도:</label>
                    <input type="number" id="minDifficulty" name="minDifficulty" min="1" max="30" value="1">

                    <label for="maxDifficulty">최대 난이도:</label>
                    <input type="number" id="maxDifficulty" name="maxDifficulty" min="1" max="30" value="30">

                    <span id="toggleDifficultyButton" class="toggle-button" onclick="toggleDifficultyTable()">난이도표 보기</span>
                    <table id="difficultyTable" class="difficulty-table" style="display: none;">
                        <thead>
                            <tr>
                                <th>난이도 값</th>
                                <th>난이도 이름</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr><td>0</td><td>Unrated / Not Ratable</td></tr>
                            <tr><td>1</td><td>Bronze V</td></tr>
                            <tr><td>2</td><td>Bronze IV</td></tr>
                            <tr><td>3</td><td>Bronze III</td></tr>
                            <tr><td>4</td><td>Bronze II</td></tr>
                            <tr><td>5</td><td>Bronze I</td></tr>
                            <tr><td>6</td><td>Silver V</td></tr>
                            <tr><td>7</td><td>Silver IV</td></tr>
                            <tr><td>8</td><td>Silver III</td></tr>
                            <tr><td>9</td><td>Silver II</td></tr>
                            <tr><td>10</td><td>Silver I</td></tr>
                            <tr><td>11</td><td>Gold V</td></tr>
                            <tr><td>12</td><td>Gold IV</td></tr>
                            <tr><td>13</td><td>Gold III</td></tr>
                            <tr><td>14</td><td>Gold II</td></tr>
                            <tr><td>15</td><td>Gold I</td></tr>
                            <tr><td>16</td><td>Platinum V</td></tr>
                            <tr><td>17</td><td>Platinum IV</td></tr>
                            <tr><td>18</td><td>Platinum III</td></tr>
                            <tr><td>19</td><td>Platinum II</td></tr>
                            <tr><td>20</td><td>Platinum I</td></tr>
                            <tr><td>21</td><td>Diamond V</td></tr>
                            <tr><td>22</td><td>Diamond IV</td></tr>
                            <tr><td>23</td><td>Diamond III</td></tr>
                            <tr><td>24</td><td>Diamond II</td></tr>
                            <tr><td>25</td><td>Diamond I</td></tr>
                            <tr><td>26</td><td>Ruby V</td></tr>
                            <tr><td>27</td><td>Ruby IV</td></tr>
                            <tr><td>28</td><td>Ruby III</td></tr>
                            <tr><td>29</td><td>Ruby II</td></tr>
                            <tr><td>30</td><td>Ruby I</td></tr>
                        </tbody>
                    </table>

                    <label for="minAcceptableUserCount">최소 제출자 수:</label>
                    <input type="number" id="minAcceptableUserCount" name="minAcceptableUserCount" value="0">

                    <label for="maxAcceptableUserCount">최대 제출자 수:</label>
                    <input type="number" id="maxAcceptableUserCount" name="maxAcceptableUserCount" value="10000000">
                </fieldset>

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
                </fieldset>
            </div>

            <button type="submit">문제 뽑기</button>
        </form>
    </div>
</body>
</html>
