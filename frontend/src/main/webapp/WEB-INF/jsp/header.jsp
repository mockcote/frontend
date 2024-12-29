<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<div id="navbar" style="background-color: #007bff; padding: 10px; text-align: center; color: white;">
    <a href="/" style="margin-right: 15px; color: white; text-decoration: none;">홈</a>
    <span id="guestButtons">
        <a href="/join" style="margin-right: 15px; color: white; text-decoration: none;">회원가입</a>
        <a href="/login" style="margin-right: 15px; color: white; text-decoration: none;">로그인</a>
    </span>
    <span id="userButtons" style="display: none;">
        <a href="/mypage" style="margin-right: 15px; color: white; text-decoration: none;">마이페이지</a>
        <a href="#" id="logoutButton" style="color: white; text-decoration: none;">로그아웃</a>
    </span>
</div>
<hr>
<script>
	const BASE_URL = "${gatewayUrl}";    
    document.addEventListener("DOMContentLoaded", () => {
        const accessToken = localStorage.getItem('accessToken');
        const guestButtons = document.getElementById('guestButtons');
        const userButtons = document.getElementById('userButtons');
        const logoutButton = document.getElementById('logoutButton');

        // 로그인 상태에 따라 버튼 표시
        if (accessToken) {
            guestButtons.style.display = 'none';
            userButtons.style.display = 'inline';
        } else {
            guestButtons.style.display = 'inline';
            userButtons.style.display = 'none';
        }

        // 로그아웃 버튼 클릭 이벤트
        logoutButton.addEventListener('click', async () => {
            try {
                const response = await fetch(BASE_URL+'/auth/logout', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                        'Authorization': `Bearer ${accessToken}`
                    },
                    credentials: 'include' // 쿠키 포함
                });

                if (response.ok) {
                    localStorage.removeItem('accessToken'); // 로컬스토리지에서 토큰 제거
                    alert('로그아웃되었습니다.');
                    location.reload(); // 페이지 새로고침
                } else {
                    alert('로그아웃에 실패했습니다.');
                }
            } catch (error) {
                console.error('로그아웃 요청 중 오류 발생:', error);
                alert('서버 오류가 발생했습니다.');
            }
        });
    });
</script>
