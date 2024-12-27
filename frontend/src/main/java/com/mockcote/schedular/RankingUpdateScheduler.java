package com.mockcote.schedular;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import org.springframework.web.reactive.function.client.WebClient;

@Service
public class RankingUpdateScheduler {
    private static final Logger logger = LoggerFactory.getLogger(RankingUpdateScheduler.class);

    private final WebClient webClient;

    @Value("${api.gateway.url}") // 환경 설정에서 API Gateway URL 가져오기
    private String gatewayUrl;

 // 생성자 주입으로 변경
    public RankingUpdateScheduler(WebClient.Builder webClientBuilder, @Value("${api.gateway.url}") String gatewayUrl) {
        this.gatewayUrl = gatewayUrl;
        this.webClient = webClientBuilder.baseUrl(gatewayUrl).build();
    }

    // 매일 자정에 실행
    @Scheduled(cron = "0 0 0 * * ?") // 매일 자정 (00:00)
//    @Scheduled(cron = "0 * * * * ?") // 매 분의 0초에 실행 (테스트용)
    public void updateTotalRanking() {
        logger.info("현재 gatewayUrl: {}", gatewayUrl);
        logger.info("스케줄러 실행: 전체 사용자 랭킹 업데이트 시작");

        try {
            // WebClient를 사용한 POST 요청
            String response = webClient.post()
                    .uri("/stats/rank/total")
                    .retrieve()
                    .bodyToMono(String.class)
                    .block(); // 동기 방식으로 처리

            logger.info("전체 사용자 랭킹 업데이트 완료: {}", response);
        } catch (Exception e) {
            logger.error("랭킹 업데이트 실패: {}", e.getMessage(), e);
        }
    }
}
