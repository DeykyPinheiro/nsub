package com.nsub.nsub;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@SpringBootApplication
@RestController
public class NsubApplication {

	public static void main(String[] args) {
		SpringApplication.run(NsubApplication.class, args);
        System.out.println("work work work");

    }


    @GetMapping("/")
    public String hello() {
        return "it workkksss??!";
    }
}
