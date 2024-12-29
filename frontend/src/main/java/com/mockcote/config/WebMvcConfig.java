package com.mockcote.config;

import com.mockcote.interceptor.AuthInterceptor;
import jakarta.annotation.PostConstruct;
import jakarta.servlet.ServletContext;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.ViewControllerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;


@Configuration
@RequiredArgsConstructor
public class WebMvcConfig implements WebMvcConfigurer {

    @Value("${api.gateway.url}")
    private String gatewayUrl;

    private final ServletContext servletContext;
    private final AuthInterceptor authInterceptor;

    @PostConstruct
    public void init() {
    	System.out.println("gatewayUrl 설정: " + gatewayUrl);
        servletContext.setAttribute("gatewayUrl", gatewayUrl);
    }

    @Override
    public void addViewControllers(ViewControllerRegistry registry) {
        registry.addViewController("/").setViewName("index");
    }

    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        registry.addInterceptor(authInterceptor)
                .addPathPatterns("/**") // 모든 URL에 대해 인터셉터 적용
                .excludePathPatterns("/", "/join", "/login", "/error"); // 특정 URL은 제외
    }
}