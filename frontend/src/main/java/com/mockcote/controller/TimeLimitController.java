package com.mockcote.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class TimeLimitController {
	// /time 요청 → timeLimit.jsp 반환
    @GetMapping("/time")
    public String timePage() {
        return "timeLimit";
    }

}
