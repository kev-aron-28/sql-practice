package com.example.jpa1.Entity;

import com.example.jpa1.TaskPriority;

import jakarta.persistence.Column;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.FetchType;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;

public class Task extends BaseEntity {
    @Column(nullable=false)
    private String title;

    @Column(length=5000)
    private String description;

    @Enumerated(EnumType.STRING)
    private TaskPriority priority;

    @ManyToOne(fetch=FetchType.LAZY)
    @JoinColumn(name="project_id")
    private Project project;

    @ManyToOne()
    @JoinColumn(name="employee_id")
    private Employee assignedEmployee;
}
