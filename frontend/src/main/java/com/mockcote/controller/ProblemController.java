package com.mockcote.controller;

import java.util.Arrays;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.reactive.function.client.WebClient;

import com.mockcote.dto.QueryProblemRequestDto;
import com.mockcote.dto.QueryProblemResponseDto;
import com.mockcote.util.LevelLoader;
import com.mockcote.util.TagLoader;

import jakarta.servlet.http.HttpSession;

@Controller
public class ProblemController {

    private final WebClient webClient;
    private static final int DEFAULT_LEVEL = 10;

    public ProblemController(WebClient.Builder webClientBuilder, @Value("${api.gateway.url}") String gatewayUrl) {
        this.webClient = webClientBuilder.baseUrl(gatewayUrl).build();
    }

    @GetMapping("/problem/list")
    public String listProblems(
            @RequestParam(required = false) String search,
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "30") int size,
            Model model) {
        if (search != null && !search.isEmpty()) {
            // 문제 ID로 단일 문제 검색
            String apiUrl = "/problems/problem/info?problemId=" + search;
            Map<String, Object> problem = webClient.get()
                    .uri(apiUrl)
                    .retrieve()
                    .bodyToMono(Map.class)
                    .block();

            if (problem != null) {
                int difficulty = (int) problem.get("difficulty");
                String levelName = LevelLoader.getLevelName(difficulty);
                problem.put("levelName", levelName);
            }

            model.addAttribute("problem", problem);
        } else {
            // 일반 목록 조회
            String apiUrl = "/problems/problem/list?page=" + page + "&size=" + size;
            Map<String, Object> response = webClient.get()
                    .uri(apiUrl)
                    .retrieve()
                    .bodyToMono(Map.class)
                    .block();

            List<Map<String, Object>> problems = (List<Map<String, Object>>) response.get("problems");
            if (problems != null) {
                for (Map<String, Object> problem : problems) {
                    int difficulty = (int) problem.get("difficulty");
                    String levelName = LevelLoader.getLevelName(difficulty);
                    problem.put("levelName", levelName);
                }
            }

            model.addAttribute("problems", problems);
            model.addAttribute("currentPage", response.get("currentPage"));
            model.addAttribute("totalPages", response.get("totalPages"));
        }
        return "problemList";
    }

    @GetMapping("/problem/rank")
    public String rankProblem(@RequestParam int problemId, Model model) {
        String apiUrl = "/stats/rank/problem/" + problemId;
        List<Map<String, Object>> ranks = webClient.get()
                .uri(apiUrl)
                .retrieve()
                .bodyToMono(List.class)
                .block();

        model.addAttribute("problemId", problemId);
        model.addAttribute("ranks", ranks);

        return "problemRank";
    }

    @GetMapping("/problem")
    public String problemPage(Model model) {
        List<Map<String, Object>> tags;
        try {
            tags = TagLoader.loadTags();
        } catch (Exception e) {
            tags = List.of();
        }

        model.addAttribute("tags", tags);
        model.addAttribute("problemMessage", "문제를 뽑아보세요!");
        return "problemPick";
    }

    @PostMapping("/problem/pick")
    public String pickProblem(
            @RequestParam("option") String option,
            @RequestParam(value = "minDifficulty", required = false, defaultValue = "1") int minDifficulty,
            @RequestParam(value = "maxDifficulty", required = false, defaultValue = "20") int maxDifficulty,
            @RequestParam(value = "minAcceptableUserCount", required = false, defaultValue = "0") int minAcceptableUserCount,
            @RequestParam(value = "maxAcceptableUserCount", required = false, defaultValue = "10000000") int maxAcceptableUserCount,
            @RequestParam(value = "desiredTags", required = false) String desiredTags,
            @RequestParam(value = "undesiredTags", required = false) String undesiredTags,
            Model model,
            @CookieValue(value = "handle", required = false) String handle, // 쿠키에서 handle 가져오기
            @CookieValue(value = "level", required = false) Integer level) {

        String problemMessage;
        Integer problemId = null;

        try {
            if ("query".equals(option)) {
                String queryApiUrl = "/problems/problem/query";

                List<Integer> desiredTagList = (desiredTags != null && !desiredTags.isBlank())
                        ? Arrays.stream(desiredTags.split(","))
                            .map(String::trim)
                            .map(Integer::parseInt)
                            .toList()
                        : List.of();

                List<Integer> undesiredTagList = (undesiredTags != null && !undesiredTags.isBlank())
                        ? Arrays.stream(undesiredTags.split(","))
                            .map(String::trim)
                            .map(Integer::parseInt)
                            .toList()
                        : List.of();

                QueryProblemRequestDto requestDto = new QueryProblemRequestDto(
                        handle != null ? handle : "", // 쿠키에서 가져온 handle 사용
                        minDifficulty,
                        maxDifficulty,
                        minAcceptableUserCount,
                        maxAcceptableUserCount,
                        desiredTagList,
                        undesiredTagList
                );

                QueryProblemResponseDto responseDto = webClient.post()
                        .uri(queryApiUrl)
                        .bodyValue(requestDto)
                        .retrieve()
                        .bodyToMono(QueryProblemResponseDto.class)
                        .block();

                if (responseDto != null) {
                    problemId = responseDto.getProblemId();
                    problemMessage = "조건 기반 문제: " + responseDto.getTitle();
                } else {
                    problemMessage = "조건에 맞는 문제가 없습니다.";
                }

            } else if ("random-tag".equals(option)) {
                // handle을 세션 대신 쿠키에서 가져온 값 사용
                if (handle == null) handle = "";
                if (level == null) level = DEFAULT_LEVEL;

                String randomTagApiUrl = "/problems/dbsave/tag/random-problem?handle=" + handle + "&level=" + level;
                problemId = webClient.get()
                        .uri(randomTagApiUrl)
                        .retrieve()
                        .bodyToMono(Integer.class)
                        .block();

                problemMessage = (problemId != null)
                        ? "취약 태그 기반 문제 ID: " + problemId
                        : "취약 태그에 맞는 문제가 없습니다.";
            } else {
                problemMessage = "올바르지 않은 선택지입니다.";
            }

            if (problemId != null) {
                String problemInfoUrl = "/problems/problem/info?problemId=" + problemId;
                Map<String, Object> problemInfo = webClient.get()
                        .uri(problemInfoUrl)
                        .retrieve()
                        .bodyToMono(Map.class)
                        .block();

                if (problemInfo != null) {
                    int difficulty = (int) problemInfo.get("difficulty");
                    String levelName = LevelLoader.getLevelName(difficulty);
                    problemInfo.put("levelName", levelName);
                    model.addAttribute("problemInfo", problemInfo);
                }
            }
        } catch (Exception e) {
            problemMessage = "문제를 뽑는 중 오류가 발생했습니다: " + e.getMessage();
        }

        model.addAttribute("problemId", problemId);
        model.addAttribute("problemMessage", problemMessage);

        return "problemResult";
    }
}
