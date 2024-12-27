package com.mockcote.config;

import jakarta.annotation.PostConstruct;
import jakarta.servlet.ServletContext;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.ViewControllerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;


@Configuration
@RequiredArgsConstructor
public class WebMvcConfig implements WebMvcConfigurer {

    @Value("${api.gateway.url}")
    private String gatewayUrl;

    private final ServletContext servletContext;

    @PostConstruct
    public void init() {
        servletContext.setAttribute("gatewayUrl", gatewayUrl);
    }

    @Override
    public void addViewControllers(ViewControllerRegistry registry) {
        registry.addViewController("/").setViewName("index");
    }
}