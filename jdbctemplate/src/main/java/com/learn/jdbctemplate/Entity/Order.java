package com.learn.jdbctemplate.Entity;

import java.time.LocalDateTime;

public record Order(
    Long id,
    Long userId,
    String status,
    LocalDateTime createdAt
) {}
