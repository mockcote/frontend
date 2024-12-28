package com.mockcote.controller;

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

import com.mockcote.model.Tag;
import com.mockcote.model.UserRanking;
import com.mockcote.util.TagLoader;

@Controller
public class StatController {

    private static final Logger logger = LoggerFactory.getLogger(StatController.class);

    private final WebClient webClient;
    private final Map<Integer, String> tagMap;

    public StatController(WebClient.Builder webClientBuilder, @Value("${api.gateway.url}") String gatewayUrl) {
        this.webClient = webClientBuilder.baseUrl(gatewayUrl).build();
        List<Map<String, Object>> tags = TagLoader.loadTags();
        this.tagMap = tags.stream()
                .collect(Collectors.toMap(
                        tag -> (Integer) tag.get("value"),
                        tag -> (String) tag.get("name")
                ));
        logger.info("태그 매핑 초기화 완료. 총 {}개의 태그가 등록되었습니다.", tagMap.size());
    }

    /**
     * /stat 엔드포인트를 처리합니다.
     *
     * @param handle 사용자 핸들 (URL 쿼리 파라미터)
     * @param model  뷰에 전달할 모델
     * @return stat.jsp 뷰 이름
     */
    @GetMapping("/stat")
    public String getUserStat(@RequestParam("handle") String handle, Model model) {
        logger.info("사용자 핸들 '{}'의 통계 정보를 가져오는 중입니다.", handle);

        try {
            // 사용자 랭킹 정보 가져오기
            String rankingUrl = "/stats/rank/user?handle=" + handle;
            UserRanking userRanking = webClient.get()
                    .uri(rankingUrl)
                    .retrieve()
                    .bodyToMono(UserRanking.class)
                    .block(); // 동기적으로 처리

            // 사용자 취약 태그 ID 목록 가져오기
            String lowestTagsUrl = "/stats/tags/lowest?handle=" + handle;
            List<Integer> lowestTagIds = webClient.get()
                    .uri(lowestTagsUrl)
                    .retrieve()
                    .bodyToMono(new ParameterizedTypeReference<List<Integer>>() {})
                    .block(); // 동기적으로 처리

            // 취약 태그 ID를 Tag 객체로 변환
            List<Tag> lowestTags = lowestTagIds.stream()
                    .map(id -> new Tag(tagMap.getOrDefault(id, "알 수 없는 태그"), id))
                    .collect(Collectors.toList());

            // 태그별 푼 문제 수 가져오기
            String tagsUrl = "/stats/tags?handle=" + handle;
            List<Map<String, Object>> tagStats = webClient.get()
                    .uri(tagsUrl)
                    .retrieve()
                    .bodyToMono(new ParameterizedTypeReference<List<Map<String, Object>>>() {})
                    .block();

            // 난이도별 푼 문제 수 가져오기
            String levelsUrl = "/stats/levels?handle=" + handle;
            List<Map<String, Object>> levelStats = webClient.get()
                    .uri(levelsUrl)
                    .retrieve()
                    .bodyToMono(new ParameterizedTypeReference<List<Map<String, Object>>>() {})
                    .block();

            // 모델에 데이터 추가
            userRanking.setHandle(handle);
            model.addAttribute("userRanking", userRanking);
            model.addAttribute("lowestTags", lowestTags);
            model.addAttribute("tagStats", tagStats);
            model.addAttribute("levelStats", levelStats);

            logger.info("사용자 핸들 '{}'의 통계 정보를 성공적으로 가져왔습니다.", handle);
        } catch (Exception e) {
            logger.error("사용자 핸들 '{}'의 통계 정보를 가져오는 중 오류가 발생했습니다.", handle, e);
            // 오류 발생 시 오류 메시지 추가
            model.addAttribute("error", "사용자 통계 정보를 가져오는 데 실패했습니다.");
        }

        return "stat";
    }
}
