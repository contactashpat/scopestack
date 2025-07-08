package com.scopestack.product.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configurers.AbstractHttpConfigurer;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.header.writers.ReferrerPolicyHeaderWriter;

/**
 * Security configuration for HTTP to HTTPS redirect and security headers.
 */
@Configuration
@EnableWebSecurity
public class SecurityConfig {

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
            // Disable CSRF for REST API (stateless)
            .csrf(AbstractHttpConfigurer::disable)
            
            // Configure HTTP to HTTPS redirect
            .requiresChannel(channel -> channel
                .anyRequest().requiresSecure()
            )
            
            // Configure authorization
            .authorizeHttpRequests(authz -> authz
                .requestMatchers("/api/**", "/swagger-ui/**", "/api-docs/**").permitAll()
                .anyRequest().authenticated()
            );

        return http.build();
    }
} 