package com.learn.jdbctemplate.Entity;

import java.time.LocalDateTime;

public record OrderItem(
    Long id,
    Long orderId,
    Long productId,
    String method,
    LocalDateTime paidAt
) {}
