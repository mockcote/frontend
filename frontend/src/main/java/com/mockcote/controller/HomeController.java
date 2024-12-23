package com.mockcote.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class HomeController {

    @GetMapping("/")
    public String index(Model model) {
        // 필요한 경우 Gateway나 다른 마이크로서비스의 API를 호출하여
        // 데이터를 받은 뒤 model에 넣어서 JSP에 전달할 수 있습니다.
        model.addAttribute("message", "Hello JSP + Spring Boot!");
        return "index"; // => /WEB-INF/jsp/index.jsp
    }
}
