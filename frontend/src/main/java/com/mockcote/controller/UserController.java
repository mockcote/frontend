package com.mockcote.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class UserController {
    // /user 요청 → user.jsp 반환
    @GetMapping("/user")
    public String userPage() {
        return "user"; 
    }
    
    // 회원가입 화면으로 이동
    @GetMapping("/join")
    public String mvJoin() {
    	return "join";
    }

    @GetMapping("/mypage")
    public String myPage(Model model) {
        // 임시로 handle 하드코딩
        model.addAttribute("handle", "3957ki");
        return "mypage";
    }

}
