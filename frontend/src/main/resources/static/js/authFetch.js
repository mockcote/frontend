// 공통 Fetch 함수
async function authFetch(url, options = {}) {
  const accessToken = localStorage.getItem("accessToken"); // 액세스 토큰 가져오기

  if (!accessToken) {
    console.error("No access token found. Redirecting to login page...");
    window.location.href = "/login"; // 로그인 페이지로 리다이렉트
    return;
  }

  // 기본 헤더 설정
  const headers = {
    ...options.headers, // 추가 헤더 병합
    Authorization: `Bearer ${accessToken}`, // 액세스 토큰 추가
  };

  // Fetch 요청
  const response = await fetch(url, {
    ...options,
    headers,
  });

  // 토큰 만료 시 처리
  if (response.status === 401) {
    console.error("Unauthorized. Redirecting to login page...");
    window.location.href = "/login"; // 로그인 페이지로 리다이렉트
    return;
  }

  if (!response.ok) {
    throw new Error(`HTTP error! Status: ${response.status}`);
  }

  return response;
}
