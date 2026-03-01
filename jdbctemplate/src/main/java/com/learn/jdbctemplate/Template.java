package com.learn.jdbctemplate;

import javax.sql.DataSource;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.jdbc.core.JdbcTemplate;

import com.zaxxer.hikari.HikariDataSource;

@Configuration
public class Template {
    
    @Bean
    DataSource dataSource() {
        HikariDataSource ds = new HikariDataSource();

        ds.setJdbcUrl("jdbc:postgresql://localhost:5432/test");

        ds.setUsername("admin");

        ds.setPassword("admin");

        return ds;
    }

    @Bean
    JdbcTemplate jdbcTemplate(DataSource db) {
        return new JdbcTemplate(db);
    }
}
