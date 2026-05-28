package com.example.jpa1.Entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;

@Entity
public class Company extends BaseEntity {
    @Column(unique=true)
    private String companyName;

    @Column(nullable=false)
    private boolean active = true;

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
