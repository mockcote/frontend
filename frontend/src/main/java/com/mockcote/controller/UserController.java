package com.mockcote.controller;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.ParameterizedTypeReference;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.reactive.function.client.WebClient;

import java.util.Map;

@Controller
public class UserController {

    private final WebClient webClient;

    public UserController(WebClient.Builder webClientBuilder, @Value("${api.gateway.url}") String gatewayUrl) {
        this.webClient = webClientBuilder.baseUrl(gatewayUrl).build();
    }

    // 회원가입 화면으로 이동
    @GetMapping("/join")
    public String mvJoin() {
    	return "join";
    }

    @GetMapping("/login")
    public String loginPage() {
        return "login";
    }
  
    @GetMapping("/mypage")
    public String myPage(Model model,
                         @CookieValue("handle") String handle,
                         @RequestParam(name = "page", defaultValue = "0") int page) {
        // 유저 통계 가져오기
        Map<String, Object> userStats = webClient.get()
                .uri("/stats/user?handle=" + handle)
                .retrieve()
                .bodyToMono(new ParameterizedTypeReference<Map<String, Object>>() {})
                .block();

        // 유저 히스토리 가져오기 (page 파라미터 활용)
        Map<String, Object> userHistory = webClient.get()
                .uri("/stats/history?handle=" + handle + "&page=" + page)
                .retrieve()
                .bodyToMono(new ParameterizedTypeReference<Map<String, Object>>() {})
                .block();

        // totalPages를 계산하기 위해 totalPages 값을 가져온다.
        int totalPages = (int) userHistory.getOrDefault("totalPages", 1);

        // 모델에 데이터 추가
        model.addAttribute("userStats", userStats);
        model.addAttribute("userHistory", userHistory);
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", totalPages);

        return "mypage";
    }

}
