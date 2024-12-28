package com.mockcote.util;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;

import java.io.InputStream;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class LevelLoader {
    private static final Map<Integer, String> levelMap = new HashMap<>();

    static {
        try {
            ObjectMapper objectMapper = new ObjectMapper();
            InputStream inputStream = LevelLoader.class.getResourceAsStream("/level.json");
            List<Map<String, Object>> levels = objectMapper.readValue(inputStream, new TypeReference<>() {});
            for (Map<String, Object> level : levels) {
                levelMap.put((Integer) level.get("value"), (String) level.get("name"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static String getLevelName(int value) {
        return levelMap.getOrDefault(value, "Unknown Level");
    }
}
