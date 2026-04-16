package com.learn.jdbctemplate.Entity;

import java.math.BigDecimal;
import java.time.LocalDateTime;

public record Payment(
    Long id,
    Long orderId,
    BigDecimal amount,
    String method,
    LocalDateTime paidAt
) {}
