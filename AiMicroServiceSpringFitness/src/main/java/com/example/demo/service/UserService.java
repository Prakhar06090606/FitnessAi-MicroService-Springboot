package com.example.demo.service;

import com.example.demo.model.Role;
import com.example.demo.model.User;
import com.example.demo.repository.RoleRepository;
import com.example.demo.repository.UserRepository;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Service
public class UserService {

    private final UserRepository userRepository;
    private final RoleRepository roleRepository;
    private final PasswordEncoder passwordEncoder;

    public UserService(UserRepository userRepository, RoleRepository roleRepository, PasswordEncoder passwordEncoder) {
        this.userRepository = userRepository;
        this.roleRepository = roleRepository;
        this.passwordEncoder = passwordEncoder;
    }
    
    // Utility Methods
    
    // Required by UserController for password verification
    public PasswordEncoder getPasswordEncoder() {
        return passwordEncoder;
    }

    // Required by UserController for session refresh (getCurrentUser)
    public Optional<User> findById(Long id) {
        return userRepository.findById(id);
    }

    public Optional<User> findByEmail(String email) {
        return userRepository.findByEmail(email);
    }

    // Authentication & Registration

    @Transactional
    public User registerUser(User user) {
        // Hash the raw password
        user.setPassword(passwordEncoder.encode(user.getPassword()));

        // Assign default role (ROLE_USER)
        Role userRole = roleRepository.findByName("ROLE_USER")
                        .orElseGet(() -> roleRepository.save(new Role("ROLE_USER")));
        user.setRole(userRole);
        
        return userRepository.save(user);
    }
    
    @Transactional
    public void updateUserPassword(User user, String newRawPassword) {
        user.setPassword(passwordEncoder.encode(newRawPassword));
        userRepository.save(user);
    }

    // Profile & Admin Methods
    
    @Transactional
    public Optional<User> updateProfile(Long userId, String firstName, String lastName, String email) {
        return userRepository.findById(userId).map(user -> {
            user.setFirstName(firstName);
            user.setLastName(lastName);
            // Only update email if it's new and available
            if (!user.getEmail().equals(email) && userRepository.findByEmail(email).isEmpty()) {
                 user.setEmail(email);
            }
            return userRepository.save(user);
        });
    }

    // Required by AdminController
    public List<User> getAllNonAdminUsers() {
        // Assumes UserRepository has findByRoleNameNot or similar method
        return userRepository.findByRoleNameNot("ROLE_ADMIN"); 
    }
    
    @Transactional
    public void toggleUserEnabled(Long userId) {
        userRepository.findById(userId).ifPresent(user -> {
            if (!"ROLE_ADMIN".equals(user.getRole().getName())) {
                user.setEnabled(!user.isEnabled());
                userRepository.save(user);
            }
        });
    }

    // Required by UserController for permanent account deletion
    @Transactional
    public void deleteUser(Long userId) {
        // JPA CascadeType.ALL should handle the deletion of associated FitnessActivities
        userRepository.deleteById(userId);
    
    }
}