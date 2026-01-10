package com.example.demo;

import org.springframework.boot.CommandLineRunner;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;

import com.example.demo.model.Role;
import com.example.demo.model.User;
import com.example.demo.repository.RoleRepository;
import com.example.demo.repository.UserRepository;

// Initializes default roles and an admin user on application startup.

@Component
public class InitialDataLoader implements CommandLineRunner {

    private final UserRepository userRepository;
    private final RoleRepository roleRepository;
    private final PasswordEncoder passwordEncoder;

    public InitialDataLoader(UserRepository userRepository, RoleRepository roleRepository, PasswordEncoder passwordEncoder) {
        this.userRepository = userRepository;
        this.roleRepository = roleRepository;
        this.passwordEncoder = passwordEncoder;
    }

    @Override
    public void run(String... args) throws Exception {
        // Create Roles if they don't exist
        Role userRole = roleRepository.findByName("ROLE_USER").orElseGet(() -> roleRepository.save(new Role("ROLE_USER")));
        Role adminRole = roleRepository.findByName("ROLE_ADMIN").orElseGet(() -> roleRepository.save(new Role("ROLE_ADMIN")));

        // Create Admin User if they don't exist
        if (userRepository.findByEmail("admin@fit.com").isEmpty()) {
            String hashedPassword = passwordEncoder.encode("adminpass");
            
            User admin = new User("admin@fit.com", hashedPassword, "Fitness", "Admin");
            admin.setRole(adminRole);
            userRepository.save(admin);
            System.out.println(" Initial Data Loaded: Admin User created with email: admin@fit.com and password: adminpass (HASHED)");
        }
 
    }
}