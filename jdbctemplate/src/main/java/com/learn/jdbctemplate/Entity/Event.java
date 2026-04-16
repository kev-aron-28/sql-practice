package com.learn.jdbctemplate.Entity;

import java.time.LocalDateTime;

public record Event(
    Long id,
    Long userId,
    String eventType,
    LocalDateTime eventTime
) {}
