package com.mockcote.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;


@Controller
public class ProblemController {
	 // [GET] /problem → 문제 뽑기 화면
    @GetMapping("/problem")
    public String problemPage(Model model) {
        // 초기에 표시할 내용이 있으면 model에 담는다.
        model.addAttribute("problemMessage", "문제를 뽑아보세요!");
        return "problemPick";
    }

    // [POST] /problem → 문제를 뽑은 후 결과 페이지 (또는 같은 페이지)
    @PostMapping("/problem")
    public String pickProblem(Model model) {
        // 예: DB나 API를 호출해서 "문제" 정보를 가져온다.
        // 여기서는 예시로 임의의 텍스트를 넣는다.
        String newProblem = "문제: 1 + 1 = ?";

        // model에 담아 JSP에서 표시할 수 있도록 한다.
        model.addAttribute("problemMessage", "새로 뽑힌 문제: " + newProblem);

        // 똑같은 JSP 파일("problemPick.jsp")을 다시 렌더링
        return "problemPick";
    }

}
