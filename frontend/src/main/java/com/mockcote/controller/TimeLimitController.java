package com.mockcote.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class TimeLimitController {
	// /time 요청 → timeLimit.jsp 반환
    @GetMapping("/time")
    public String timePage(@RequestParam int problemId, @RequestParam int limitTime, Model model) {
        model.addAttribute("problemId", problemId);
        model.addAttribute("limitTime", limitTime);
        return "timeLimit";
    }

}
