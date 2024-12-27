package com.mockcote.controller;

import org.springframework.stereotype.Controller;
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

}
