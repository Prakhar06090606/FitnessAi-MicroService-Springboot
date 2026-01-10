package com.example.demo.model;

import jakarta.persistence.*;

//Defines the user roles (ROLE_USER, ROLE_ADMIN).

@Entity
public class Role {
	
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(unique = true, nullable = false)
    private String name; // "ROLE_USER", "ROLE_ADMIN"

    // Constructors
    public Role() {}
    public Role(String name) { this.name = name; }

    // Getters and Setters
    public Long getId(){ return id; }
    public void setId(Long id){ this.id = id; }
    public String getName(){ return name; }
    public void setName(String name){ this.name = name; }
}