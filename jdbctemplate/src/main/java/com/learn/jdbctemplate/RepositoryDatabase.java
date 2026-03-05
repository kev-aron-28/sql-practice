package com.learn.jdbctemplate;

import java.sql.Types;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

@Repository
public class RepositoryDatabase {
    JdbcTemplate template;

    public RepositoryDatabase(JdbcTemplate template) {
        this.template = template;
    }
    
    public void action() {
        String query = """
                INSERT INTO users(name, email) values (?,?)
                """;
        String name ="";
        String email = "";

        template.update(query,
            new Object[] { name, null },
            new int[] { Types.VARCHAR, Types.VARCHAR }
        );


    }
}
