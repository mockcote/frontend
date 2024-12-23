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


}
