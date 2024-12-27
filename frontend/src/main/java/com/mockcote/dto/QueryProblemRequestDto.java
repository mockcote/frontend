package com.mockcote.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class QueryProblemRequestDto {
    private String handle; // 사용자 핸들
    private int minDifficulty; // 최소 난이도
    private int maxDifficulty; // 최대 난이도
    private int minAcceptableUserCount; 
    private int maxAcceptableUserCount; 
    private List<Integer> desiredTags; // 선호 태그 리스트
    private List<Integer> undesiredTags; // 비선호 태그 리스트
}
