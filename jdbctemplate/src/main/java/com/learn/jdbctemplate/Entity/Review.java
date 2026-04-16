package com.learn.jdbctemplate.Entity;

import java.time.LocalDateTime;

public record Review(
    Long id,
    Long userId,
    Long productId,
    Integer rating,
    String comment,
    LocalDateTime createdAT
) {}
