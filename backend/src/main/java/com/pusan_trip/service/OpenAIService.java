package com.pusan_trip.service;

import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.*;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
@Slf4j
public class OpenAIService {

    @Value("${openai.api.key}")
    private String apiKey;

    @Value("${openai.api.url}")
    private String apiUrl;

    private final RestTemplate restTemplate = new RestTemplate();
    private final ObjectMapper objectMapper = new ObjectMapper();

    public String generateSummary(String content) {
        try {
            // GPT API 요청 본문 구성
            Map<String, Object> requestBody = Map.of(
                "model", "gpt-3.5-turbo",
                "messages", List.of(
                    Map.of(
                        "role", "system",
                        "content", "다음 게시글 내용을 한국어로 3-4줄 정도의 요약문으로 작성해주세요. 핵심 내용과 주요 포인트를 포함하여 간결하게 요약해주세요. 또한 '포함되어있습니다' 와 같이 딱딱한 말을 사용하지 마세요."
                    ),
                    Map.of(
                        "role", "user",
                        "content", content
                    )
                ),
                "max_tokens", 200,
                "temperature", 0.7
            );

            // HTTP 헤더 설정
            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_JSON);
            headers.setBearerAuth(apiKey);

            // HTTP 엔티티 생성
            HttpEntity<Map<String, Object>> entity = new HttpEntity<>(requestBody, headers);

            // GPT API 호출
            ResponseEntity<String> response = restTemplate.postForEntity(apiUrl, entity, String.class);

            return extractSummaryFromResponse(response.getBody());

        } catch (Exception e) {
            log.error("GPT API 호출 중 오류 발생: ", e);
            return content.length() > 100 ? content.substring(0, 100) + "..." : content;
        }
    }

    private String extractSummaryFromResponse(String response) {
        try {
            Map<String, Object> responseMap = objectMapper.readValue(response, Map.class);
            List<Map<String, Object>> choices = (List<Map<String, Object>>) responseMap.get("choices");
            
            if (choices != null && !choices.isEmpty()) {
                Map<String, Object> firstChoice = choices.get(0);
                Map<String, Object> message = (Map<String, Object>) firstChoice.get("message");
                return (String) message.get("content");
            }
            
            log.warn("GPT API 응답에서 요약 내용을 찾을 수 없습니다.");
            return "요약 생성에 실패했습니다.";
            
        } catch (Exception e) {
            log.error("GPT API 응답 파싱 중 오류 발생: ", e);
            return "요약 생성에 실패했습니다.";
        }
    }
} 