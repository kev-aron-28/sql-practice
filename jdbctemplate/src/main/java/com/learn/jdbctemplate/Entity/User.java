package com.learn.jdbctemplate.Entity;

import java.time.LocalDateTime;

public record User(
    Long id, 
    String name,
    String email,
    String country,
    LocalDateTime createdAt
) {}
