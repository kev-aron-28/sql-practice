package com.example.jpa1.Entity;

import java.math.BigDecimal;
import java.time.LocalDateTime;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.FetchType;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;

@Entity
public class Project extends BaseEntity {
    
    @Column(nullable=false)
    private String name;

    private String description;

    private LocalDateTime startDate;

    private LocalDateTime dueDate;

    @Enumerated(EnumType.STRING)
    private ProjectStatus status;

    @Column(precision=15,scale=2)
    private BigDecimal budget;


    @ManyToOne(fetch=FetchType.LAZY)
    @JoinColumn(name = "company_id")
    private Company company;
}
