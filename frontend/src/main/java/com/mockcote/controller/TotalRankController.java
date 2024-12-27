package com.mockcote.controller;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.ParameterizedTypeReference;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.reactive.function.client.WebClient;

import com.mockcote.model.UserRanking;

@Controller
public class TotalRankController {

    private static final Logger logger = LoggerFactory.getLogger(TotalRankController.class);

    private final WebClient webClient;

    public TotalRankController(WebClient.Builder webClientBuilder, @Value("${api.gateway.url}") String gatewayUrl) {
        this.webClient = webClientBuilder.baseUrl(gatewayUrl).build();
    }

    @GetMapping("/rank/total")
    public String getTotalRank(
            @RequestParam(value = "page", defaultValue = "0") int page,
            @RequestParam(value = "size", defaultValue = "20") int size,
            Model model) {
        logger.info("전체 랭킹 정보를 가져오는 중 (page={}, size={})", page, size);

        try {
            String url = "/stats/rank/all?page=" + page + "&size=" + size;

            // 명시적으로 타입을 지정
            Map<String, Object> response = webClient.get()
                    .uri(url)
                    .retrieve()
                    .bodyToMono(new ParameterizedTypeReference<Map<String, Object>>() {})
                    .block();

            // JSON 데이터를 UserRanking 객체 리스트로 변환
            List<LinkedHashMap<String, Object>> content = (List<LinkedHashMap<String, Object>>) response.get("content");
            List<UserRanking> rankings = content.stream()
                    .map(data -> {
                        UserRanking ranking = new UserRanking();
                        ranking.setHandle((String) data.get("handle"));
                        ranking.setScore((Integer) data.get("score"));
                        ranking.setRanking((Integer) data.get("ranking"));
                        return ranking;
                    })
                    .collect(Collectors.toList());

            model.addAttribute("rankings", rankings);
            model.addAttribute("pageNumber", page);
            model.addAttribute("totalPages", response.get("totalPages"));
            model.addAttribute("totalElements", response.get("totalElements"));
            model.addAttribute("size", size);

            logger.info("전체 랭킹 정보 가져오기 성공");
        } catch (Exception e) {
            logger.error("전체 랭킹 정보를 가져오는 중 오류 발생: {}", e.getMessage(), e);
            model.addAttribute("error", "전체 랭킹 정보를 가져오는 데 실패했습니다.");
        }

        return "totalrank";
    }

}
