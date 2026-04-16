package com.learn.jdbctemplate;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.ApplicationContext;

@SpringBootApplication
public class JdbctemplateApplication {

	public static void main(String[] args) {
		ApplicationContext cntx = SpringApplication.run(JdbctemplateApplication.class, args);
	
		Analytics repo = cntx.getBean(Analytics.class);
		
		System.out.println(
			repo.findUserFromMexico()
		);

	}

}
