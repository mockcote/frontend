package com.mockcote.controller;

import org.springframework.http.HttpStatus;
import org.springframework.http.HttpStatusCode;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.server.ResponseStatusException;

import jakarta.servlet.http.HttpServletRequest;

@ControllerAdvice
public class GlobalExceptionHandler {
	
	@ExceptionHandler(ResponseStatusException.class)
	public String handleException(ResponseStatusException e, Model model) {
		
		HttpStatusCode status = e.getStatusCode();
		
		model.addAttribute("status", status);
		model.addAttribute("message", e.getMessage() != null ? e.getMessage() : "오류가 발생했습니다. 다시 시도해 주십시오.");
		
		return "error";
	}
}
