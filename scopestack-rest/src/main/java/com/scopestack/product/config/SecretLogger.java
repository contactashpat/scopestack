package com.scopestack.product.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

@Component
public class SecretLogger implements CommandLineRunner {

    @Value("${jwt-secret:NOT_FOUND}")
    private String jwtSecret;

    @Override
    public void run(String... args) {
        System.out.println("Loaded JWT Secret from OpenBao: " + jwtSecret);
    }
} 