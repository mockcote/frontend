package com.mockcote.controller;

import jakarta.servlet.http.HttpServletRequest;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.reactive.function.client.WebClient;

import java.util.Map;

@Controller
@Slf4j
@RequestMapping("/time")
public class TimeLimitController {

    private final WebClient webClient;

    public TimeLimitController(WebClient.Builder webClientBuilder, @Value("${api.gateway.url}") String gatewayUrl) {
        this.webClient = webClientBuilder.baseUrl(gatewayUrl).build();
    }

	// /time 요청 → timeLimit.jsp 반환
    @GetMapping
    public String timePage(@CookieValue("handle") String handle,
                           @RequestParam int problemId,
                           @RequestParam int limitTime,
                           HttpServletRequest request,
                           Model model) {

        log.info("Authorization : {}", request.getHeader("Authorization"));
        // 풀이 시작
        String startTime = webClient.post()
                .uri("/submissions/start")
                .header("Authorization", request.getHeader("Authorization"))
                .bodyValue(Map.of("handle", handle, "problemId", problemId))
                .retrieve()
                .bodyToMono(String.class)
                .block();

        model.addAttribute("startTime", startTime);
        model.addAttribute("limitTime", limitTime);
        model.addAttribute("problemId", problemId);
        return "timeLimit";
    }

    // 풀이 여부 체크
    @PostMapping("/checkSubmission")
    @ResponseBody
    public String checkSubmission(
            @RequestParam("handle") String handle,
            @RequestParam("problemId") int problemId,
            HttpServletRequest request
    ) {
        // WebClient를 사용하여 API 호출
        String status = webClient.get()
                .uri("/submissions/result?handle=" + handle + "&problemId=" + problemId)
                .header("Authorization", request.getHeader("Authorization"))
                .retrieve()
                .bodyToMono(String.class)
                .block();

        // 결과 반환 (SUCCESS 또는 FAIL)
        return status.trim();
    }

    // 풀이 로그 저장
    @PostMapping("/saveSubmission")
    @ResponseBody
    public ResponseEntity<?> saveSubmission(
            @RequestParam("handle") String handle,
            @RequestParam("problemId") int problemId,
            @RequestParam("startTime") String startTime,
            @RequestParam("limitTime") int limitTime,
            @RequestParam("language") String language,
            @RequestParam("status") String status,
            HttpServletRequest request
    ) {
        // 요청 데이터 구성
        Map<String, Object> requestBody = Map.of(
                "handle", handle,
                "problemId", problemId,
                "startTime", startTime,
                "limitTime", limitTime,
                "language", language,
                "status", status
        );
    
        // WebClient를 사용해 로그 저장 API 호출
        webClient.post()
                .uri("/submissions/save")
                .header("Authorization", request.getHeader("Authorization"))
                .bodyValue(requestBody)
                .retrieve()
                .toBodilessEntity()
                .block();

        // 사용자 점수 +1
        webClient.post()
                .uri("/stats/rank/increment-score?handle=" + handle)
                .retrieve()
                .toBodilessEntity()
                .block();
    
        return ResponseEntity.ok("Submission saved successfully");
    }

    // 그만하기
    @PostMapping("/endSubmission")
    @ResponseBody
    public ResponseEntity<?> endSubmission(
            @RequestParam("handle") String handle,
            @RequestParam("problemId") int problemId,
            HttpServletRequest request
    ) {
        // WebClient로 종료 API 호출
        webClient.post()
                .uri("/submissions/end")
                .header("Authorization", request.getHeader("Authorization"))
                .bodyValue(Map.of("handle", handle, "problemId", problemId))
                .retrieve()
                .toBodilessEntity()
                .block();

        return ResponseEntity.noContent().build(); // 클라이언트에 상태 204 반환
    }

}
