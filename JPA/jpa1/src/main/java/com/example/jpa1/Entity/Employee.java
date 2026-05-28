package com.example.jpa1.Entity;

import java.time.LocalDateTime;

import org.hibernate.annotations.ManyToAny;

import com.example.jpa1.EmployeeStatus;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.FetchType;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;

@Entity
public class Employee extends BaseEntity {
    @Column(nullable=false)
    private String firstName;

    @Column(nullable=false)
    private String lastName;

    @Column(unique=true,nullable=false)
    private String email;

    @Column(nullable=false)
    private Long salary;

    @Enumerated(EnumType.STRING)
    private EmployeeStatus status;

    private LocalDateTime hiredAt;

    @ManyToAny(fetch=FetchType.LAZY)
    @JoinColumn(name="department_id")
    private Department department;

    @ManyToOne(fetch=FetchType.LAZY)
    @JoinColumn(name="manager_id")
    private Employee manager;
    
}
