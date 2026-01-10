package com.example.demo.controller;

import com.example.demo.model.User;
import com.example.demo.service.EmailService;
import com.example.demo.service.UserService;
import jakarta.servlet.http.HttpSession;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.Optional;

@Controller
public class AuthController {

    private final UserService userService;
    private final EmailService emailService;
    private final PasswordEncoder passwordEncoder;

    public AuthController(UserService userService, EmailService emailService, PasswordEncoder passwordEncoder) {
        this.userService = userService;
        this.emailService = emailService;
        this.passwordEncoder = passwordEncoder;
    }
    
    // Handle the application root path (/)
    @GetMapping("/")
    public String handleRoot(HttpSession session) {
        // If the session has no current user, redirect directly to the login page.
        if (session.getAttribute("currentUser") == null) {
            return "redirect:/login"; 
        }
        // If authenticated, redirect them to the protected dashboard endpoint.
        return "redirect:/dashboard"; 
    }

    // Login Page
    
    @GetMapping("/login")
    public String showLoginForm(HttpSession session) {
        // If the user is already logged in, redirect them to the dashboard immediately.
        if (session.getAttribute("currentUser") != null) {
            // Use UserController's protected /dashboard endpoint for routing
            return "redirect:/dashboard"; 
        }
        return "login";
    }

    @PostMapping("/login")
    public String login(
            @RequestParam String email,
            @RequestParam String password,
            HttpSession session,
            Model model
    ) {
        Optional<User> userOpt = userService.findByEmail(email);

        if (userOpt.isEmpty()) {
            // Specific error message for unregistered email
            model.addAttribute("error", "Your email is not registered. Please sign up.");
            return "login";
        }

        User user = userOpt.get();
        
        // Hashing check
        if (passwordEncoder.matches(password, user.getPassword())) {
            session.setAttribute("currentUser", user);
            // Assuming role setup exists
            session.setAttribute("role", user.getRole().getName());
            
            if ("ROLE_ADMIN".equals(user.getRole().getName())) {
                return "redirect:/admin/dashboard";
            }
            return "redirect:/dashboard"; // Redirect to the protected dashboard
        } else {
            model.addAttribute("error", "Invalid email or password.");
            return "login";
        }
    }

    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/login";
    }
    
    // Registration Endpoints
    
    @GetMapping("/register")
    public String showRegistrationForm(Model model) {
        if (!model.containsAttribute("user")) {
            model.addAttribute("user", new User()); 
        }
        return "register";
    }

    @PostMapping("/register")
    public String registerUser(
            @RequestParam String email,
            @RequestParam String password,
            @RequestParam String confirmPassword,
            @RequestParam String firstName,
            @RequestParam String lastName,
            RedirectAttributes redirectAttributes
    ) {
        // Validation logic
    	if (password.length() < 8) {
            redirectAttributes.addFlashAttribute("error", "Password must be at least 8 characters.");
            return "redirect:/register";
        }
        if (!password.equals(confirmPassword)) {
            redirectAttributes.addFlashAttribute("error", "Password and confirmation do not match.");
            return "redirect:/register";
        }
        if (userService.findByEmail(email).isPresent()) {
            redirectAttributes.addFlashAttribute("error", "Email already registered.");
            return "redirect:/register";
        }
        
        String passwordRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[@#$%^&+=!]).{8,16}$";
        
        if (!password.matches(passwordRegex)) {
            redirectAttributes.addFlashAttribute("error", 
                "Password must be 8-16 characters long and contain at least one uppercase letter, one lowercase letter, one number, and one special character (@, #, $, etc.).");
            return "redirect:/register";
        }

        User newUser = new User(email, password, firstName, lastName);
        userService.registerUser(newUser);

        // Assuming external application.properties is configured for email sending
        emailService.sendWelcomeEmail(email, firstName + " " + lastName);

        redirectAttributes.addFlashAttribute("message", "Registration successful! Please log in.");
        return "redirect:/login";
    }
    
    // Forgot/Reset Password Endpoints
    
    @GetMapping("/forgot-password")
    public String showForgotPasswordForm() {
        return "forgot-password";
    }
    
    @PostMapping("/forgot-password")
    public String processForgotPassword(@RequestParam("email") String email, RedirectAttributes redirectAttributes) {
        Optional<User> userOpt = userService.findByEmail(email);
        
        if (userOpt.isPresent()) {
            String resetLink = "http://localhost:8080/reset-password?email=" + email + "&token=MOCK_TOKEN_FIT";
            emailService.sendPasswordResetEmail(email, resetLink);
        }
        
        redirectAttributes.addFlashAttribute("message", "If an account exists, a password reset link has been sent to your email.");
        return "redirect:/forgot-password";
    }
    
    @GetMapping("/reset-password")
    public String showResetPasswordForm(@RequestParam String email, @RequestParam String token, Model model) {
        if (!"MOCK_TOKEN_FIT".equals(token) || userService.findByEmail(email).isEmpty()) {
             model.addAttribute("error", "Invalid or expired reset link.");
             return "login";
        }
        model.addAttribute("email", email);
        model.addAttribute("token", token);
        return "reset-password";
    }
    
    @PostMapping("/reset-password")
    public String resetPassword(@RequestParam String email, @RequestParam String newPassword, @RequestParam String confirmNewPassword, RedirectAttributes redirectAttributes) {
        if (!newPassword.equals(confirmNewPassword) || newPassword.length() < 8) {
            redirectAttributes.addFlashAttribute("error", "New passwords do not match or are too short (min 8 characters).");
            return "redirect:/reset-password?email=" + email + "&token=MOCK_TOKEN_FIT"; // Must send token back!
        }
        
        Optional<User> userOpt = userService.findByEmail(email);
        if (userOpt.isPresent()) {
            userService.updateUserPassword(userOpt.get(), newPassword); 
            redirectAttributes.addFlashAttribute("message", "Your password has been reset successfully! Please log in.");
            return "redirect:/login";
        }
        redirectAttributes.addFlashAttribute("error", "User not found.");
        return "redirect:/login";
    }
}