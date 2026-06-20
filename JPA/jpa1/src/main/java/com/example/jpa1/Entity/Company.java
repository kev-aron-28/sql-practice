package com.example.jpa1.Entity;

import java.util.ArrayList;
import java.util.List;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.OneToMany;

@Entity
public class Company extends BaseEntity {
    @Column(unique=true)
    private String companyName;

    @Column(nullable=false)
    private boolean active = true;

    @OneToMany(mappedBy="company")
    private List<Project> projects = new ArrayList<>();

    public Company() {
    }

    public String getCompanyName() {
        return companyName;
    }

    public void setCompanyName(String companyName) {
        this.companyName = companyName;
    }

    public boolean isActive() {
        return active;
    }

    public void setActive(boolean active) {
        this.active = active;
    }
}
