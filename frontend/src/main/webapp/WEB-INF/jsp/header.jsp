<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<div id="navbar" style="background-color: #007bff; padding: 10px; text-align: center; color: white;">
    <a href="/" style="margin-right: 15px; color: white; text-decoration: none;">홈</a>
    <a href="/rank/total" style="margin-right: 15px; color: white; text-decoration: none;">전체 사용자 랭킹</a>
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
                console.log('로그아웃 요청 시작'); // 로그아웃 요청 시작 로그
                const response = await fetch(BASE_URL + '/auth/logout', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                        'Authorization': `Bearer ${accessToken}`
                    },
                    credentials: 'include' // 쿠키 포함
                });

                // 응답 상태 및 데이터 확인
                console.log('응답 상태:', response.status);
                console.log('응답 상태 텍스트:', response.statusText);

                if (response.ok) {
                    // 로컬 스토리지 및 세션 스토리지 정보 제거
                    localStorage.removeItem('accessToken'); // 로컬스토리지에서 토큰 제거
                    alert('로그아웃되었습니다.');
                    location.reload(); // 페이지 새로고침
                } else {
                    const errorData = await response.json();
                    console.error('로그아웃 실패 상세:', errorData); // 서버가 보낸 에러 메시지
                    alert(`로그아웃에 실패했습니다. 상태 코드: ${response.status}`);
                }
            } catch (error) {
                console.error('로그아웃 요청 중 오류 발생:', error);
                alert('서버 오류가 발생했습니다.');
            }
        });
    });
</script>
