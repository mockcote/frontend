package com.mockcote.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class QueryProblemResponseDto {
    private int problemId;
    private String title;
    private int difficulty;
    private int acceptableUserCount;
}
