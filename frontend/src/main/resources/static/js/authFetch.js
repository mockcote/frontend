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
  let response = await fetch(url, {
    ...options,
    headers,
  });

  // 토큰 만료 시 재발급 시도
  if (response.status === 401) {
    console.log("Access token expired. Refreshing token...");
    const refreshResponse = await fetch("http://localhost:8080/auth/refresh", {
      credentials: 'include', // 쿠키 포함 (리프레시 토큰)
    });

    if (refreshResponse.ok) {
      // 새로운 액세스 토큰 저장
      const data = await refreshResponse.json();
      localStorage.setItem("accessToken", data.accessToken);

      // 새로운 토큰으로 원래 요청 다시 시도
      headers.Authorization = `Bearer ${data.accessToken}`;
      response = await fetch(url, {
        ...options,
        headers,
      });
    } else {
      console.error("Failed to refresh token. Redirecting to login page...");
      window.location.href = "/login"; // 로그인 페이지로 리다이렉트
      return;
    }
  }

  if (!response.ok) {
    throw new Error(`HTTP error! Status: ${response.status}`);
  }

  return response;
}
