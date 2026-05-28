package com.example.jpa1.Entity;

import java.math.BigDecimal;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;

@Entity
public class Department extends BaseEntity {
    @Column(unique=true,nullable = false)
    private String name;

    @Column(nullable=false)
    private String code;

    @Column(nullable=false,precision=15,scale=2)
    private BigDecimal budget;

    @ManyToOne(fetch=FetchType.LAZY)
    @JoinColumn(name="company_id", nullable=false)
    private Company company;

    

}
