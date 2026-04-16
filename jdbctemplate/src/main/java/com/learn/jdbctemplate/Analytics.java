package com.learn.jdbctemplate;

import java.time.LocalDateTime;
import java.util.List;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import com.learn.jdbctemplate.Entity.Product;
import com.learn.jdbctemplate.Entity.User;

@Repository
public class Analytics {
     
    private final JdbcTemplate template;

    public Analytics(JdbcTemplate template) {
        this.template = template;
    }

    public List<User> findUserFromMexico() {
        String query = """
                SELECT * FROM users where country = ?
                """;

        List<User> users = template.query(
            query, 
            (rs, rowNumber) -> new User(
                rs.getLong("id"),
                rs.getString("name"),
                rs.getString("email"),
                rs.getString("country"),
                rs.getObject("created_at", LocalDateTime.class)
            ),
            "MX"
        );

        return users;
    }

    public List<Product> findProductByCategoryElectronics() {
        String query = """
                SELECT * FROM products where category = ?
                """;
        
        List<Product> products = template.query(
            query, 
            (rs, rowNumber) -> new Product(
                rs.getLong("id"),
                rs.getString("name"),
                rs.getString("category"),
                rs.getBigDecimal("price"),
                rs.getObject("created_at", LocalDateTime.class)
            ),
            "electronics"
        );

        return products;
    }

}
