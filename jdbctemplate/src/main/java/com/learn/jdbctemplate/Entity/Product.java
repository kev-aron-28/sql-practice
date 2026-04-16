package com.learn.jdbctemplate.Entity;

import java.math.BigDecimal;
import java.time.LocalDateTime;

public record Product(
    Long id,
    String name,
    String category,
    BigDecimal price,
    LocalDateTime createdAt
) {
    
}
