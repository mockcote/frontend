package com.mockcote.util;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;

import java.io.IOException;
import java.io.InputStream;
import java.util.List;
import java.util.Map;

public class TagLoader {

    private static final String TAGS_FILE = "/tags.json";

    public static List<Map<String, Object>> loadTags() {
        ObjectMapper objectMapper = new ObjectMapper();
        try (InputStream inputStream = TagLoader.class.getResourceAsStream(TAGS_FILE)) {
            return objectMapper.readValue(inputStream, new TypeReference<List<Map<String, Object>>>() {});
        } catch (IOException e) {
            throw new RuntimeException("태그 정보를 로드하는 중 오류가 발생했습니다.", e);
        }
    }
}
