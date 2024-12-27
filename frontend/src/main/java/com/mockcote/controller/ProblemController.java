package com.mockcote.controller;

import java.util.Arrays;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.client.RestTemplate;

import com.mockcote.dto.QueryProblemRequestDto;
import com.mockcote.dto.QueryProblemResponseDto;
import com.mockcote.util.LevelLoader;
import com.mockcote.util.TagLoader;

import jakarta.servlet.http.HttpSession;

@Controller
public class ProblemController {

    private final RestTemplate restTemplate = new RestTemplate();
    private static final String DEFAULT_HANDLE = "rlaekwjd6545";
    private static final int DEFAULT_LEVEL = 10;
    
    @Value("${api.gateway.url}") // 환경 설정에서 API Gateway URL 가져오기
    private String gatewayUrl;
    
    @GetMapping("/problem/list")
    public String listProblems(
            @RequestParam(required = false) String search,
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "30") int size,
            Model model) {
        if (search != null && !search.isEmpty()) {
            // 문제 ID로 단일 문제 검색
            String apiUrl = gatewayUrl + "/problems/problem/info?problemId=" + search;
            Map<String, Object> problem = restTemplate.getForObject(apiUrl, Map.class);

            if (problem != null) {
                int difficulty = (int) problem.get("difficulty");
                String levelName = LevelLoader.getLevelName(difficulty); // 난이도 이름 가져오기
                problem.put("levelName", levelName); // 난이도 이름 추가
            }

            model.addAttribute("problem", problem);
        } else {
            // 일반 목록 조회
            String apiUrl = gatewayUrl + "/problems/problem/list?page=" + page + "&size=" + size;
            Map<String, Object> response = restTemplate.getForObject(apiUrl, Map.class);

            List<Map<String, Object>> problems = (List<Map<String, Object>>) response.get("problems");
            if (problems != null) {
                // 모든 문제에 대해 난이도 이름 추가
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
        String apiUrl = gatewayUrl + "/stats/rank/problem/" + problemId;
        List<Map<String, Object>> ranks = restTemplate.getForObject(apiUrl, List.class);

        model.addAttribute("problemId", problemId);
        model.addAttribute("ranks", ranks);

        return "problemRank";
    }

    // [GET] /problem 요청 처리 → JSP 파일 렌더링
    @GetMapping("/problem")
    public String problemPage(Model model) {
        // 태그 정보를 동적으로 로드
        List<Map<String, Object>> tags;
        try {
            tags = TagLoader.loadTags(); // 태그 로드 시도
        } catch (Exception e) {
            tags = List.of(); // 로드 실패 시 빈 리스트로 초기화
        }

        model.addAttribute("tags", tags);
        model.addAttribute("problemMessage", "문제를 뽑아보세요!");
        return "problemPick";
    }


    // [POST] /problem/pick 요청 처리 → 문제 뽑기 로직
    @PostMapping("/problem/pick")
    public String pickProblem(@RequestParam("option") String option,
                              @RequestParam(value = "minDifficulty", required = false, defaultValue = "1") int minDifficulty,
                              @RequestParam(value = "maxDifficulty", required = false, defaultValue = "20") int maxDifficulty,
                              @RequestParam(value = "minAcceptableUserCount", required = false, defaultValue = "0") int minAcceptableUserCount,
                              @RequestParam(value = "maxAcceptableUserCount", required = false, defaultValue = "10000000") int maxAcceptableUserCount,
                              @RequestParam(value = "desiredTags", required = false) String desiredTags,
                              @RequestParam(value = "undesiredTags", required = false) String undesiredTags,
                              Model model,
                              HttpSession session) {

        String problemMessage;
        Integer problemId = null;

        try {
            if ("query".equals(option)) {
                // 조건 기반 문제 뽑기 API 호출
            	String queryApiUrl = gatewayUrl + "/problems/problem/query"; // 게이트웨이 URL 사용

            	// 태그 입력값을 List<Integer>로 변환, null일 경우 빈 리스트 처리
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
                        DEFAULT_HANDLE,  // Session에서 handle 가져오기
                        minDifficulty,
                        maxDifficulty,
                        minAcceptableUserCount,
                        maxAcceptableUserCount,
                        desiredTagList,
                        undesiredTagList
                );

                QueryProblemResponseDto responseDto = restTemplate.postForObject(queryApiUrl, requestDto, QueryProblemResponseDto.class);

                if (responseDto != null) {
                    problemId = responseDto.getProblemId();
                    problemMessage = "조건 기반 문제: " + responseDto.getTitle();
                } else {
                    problemMessage = "조건에 맞는 문제가 없습니다.";
                }

            } else if ("random-tag".equals(option)) {
                // 세션에서 handle과 level 가져오기
                String handle = (String) session.getAttribute("handle");
                Integer level = (Integer) session.getAttribute("level");

                // 세션에 값이 없는 경우 기본값 사용
                if (handle == null) {
                    handle = DEFAULT_HANDLE;
                }
                if (level == null) {
                    level = DEFAULT_LEVEL;
                }

                // 취약 태그 기반 문제 뽑기 API 호출
                String randomTagApiUrl = gatewayUrl + "/problems/dbsave/tag/random-problem?handle=" + handle + "&level=" + level;
                problemId = restTemplate.getForObject(randomTagApiUrl, Integer.class);

                if (problemId != null) {
                    problemMessage = "취약 태그 기반 문제 ID: " + problemId;
                } else {
                    problemMessage = "취약 태그에 맞는 문제가 없습니다.";
                }

            } else {
                problemMessage = "올바르지 않은 선택지입니다.";
            }

            if (problemId != null) {
                // 문제 정보 조회 API 호출
            	String problemInfoUrl = gatewayUrl + "/problems/problem/info?problemId=" + problemId;
                Map<String, Object> problemInfo = restTemplate.getForObject(problemInfoUrl, Map.class);

                if (problemInfo != null) {
                    int difficulty = (int) problemInfo.get("difficulty");
                    String levelName = LevelLoader.getLevelName(difficulty);
                    problemInfo.put("levelName", levelName); // 난이도 이름 추가
                    model.addAttribute("problemInfo", problemInfo);
                }
            }
        } catch (Exception e) {
            problemMessage = "문제를 뽑는 중 오류가 발생했습니다: " + e.getMessage();
        }

     // 문제 ID와 메시지 전달
        model.addAttribute("problemId", problemId);
        model.addAttribute("problemMessage", problemMessage);

        return "problemResult"; // 새로운 JSP로 이동
    }
}