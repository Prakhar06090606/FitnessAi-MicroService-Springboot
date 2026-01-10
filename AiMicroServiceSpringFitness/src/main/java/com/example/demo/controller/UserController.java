package com.example.demo.controller;

import com.example.demo.model.ActivityType;
import com.example.demo.model.FitnessActivity;
import com.example.demo.model.User;
import com.example.demo.service.FitnessService;
import com.example.demo.service.UserService;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.Optional;

@Controller
public class UserController {

    private final FitnessService fitnessService;
    private final UserService userService;

    public UserController(FitnessService fitnessService, UserService userService) {
        this.fitnessService = fitnessService;
        this.userService = userService;
    }

    //Retrieves the current user from the session and attempts to refresh their data from the database.
    
    private User getCurrentUser(HttpSession session) {
        User sessionUser = (User) session.getAttribute("currentUser");
        if (sessionUser != null) {
            // Attempt to refresh data from the DB
            return userService.findById(sessionUser.getId()).orElse(sessionUser); 
        }
        return null;
    }

    // User Dashboard
    @GetMapping("/dashboard")
    public String showUserDashboard(HttpSession session, Model model) {
        User currentUser = getCurrentUser(session);
        
        // Security Check: If the user is NOT logged in, redirect them.
        if (currentUser == null) {
            return "redirect:/login"; 
        }

        // Admin is authenticated and proceeds to view the user features.
        session.setAttribute("currentUser", currentUser);
        
        model.addAttribute("user", currentUser);
        model.addAttribute("activityTypes", ActivityType.values());
        model.addAttribute("activities", fitnessService.getUserActivities(currentUser.getId()));

        return "index"; // Renders index.jsp
    }
    
    // View Activity Details
    @GetMapping("/activity/{id}")
    public String showActivityDetails(@PathVariable Long id, HttpSession session, Model model, RedirectAttributes redirectAttributes) {
        User currentUser = getCurrentUser(session);
        if (currentUser == null) return "redirect:/login";

        Optional<FitnessActivity> activityOpt = fitnessService.getActivityById(id);
        
        // Security Check: Ensure activity exists AND belongs to the current user (or is admin)
        boolean isAdmin = "ROLE_ADMIN".equals(session.getAttribute("role"));
        
        if (activityOpt.isEmpty() || (!isAdmin && !activityOpt.get().getUser().getId().equals(currentUser.getId()))) {
            redirectAttributes.addFlashAttribute("error", "Activity not found or unauthorized access.");
            return "redirect:/dashboard";
        }
        
        model.addAttribute("activity", activityOpt.get());
        model.addAttribute("role", session.getAttribute("role")); 
        return "activity-details";
    }

    // Create New Activity
    @PostMapping("/activity/new")
    public String createNewActivity(
            @RequestParam ActivityType activityType,
            @RequestParam int durationMinutes,
            @RequestParam int caloriesBurned,
            @RequestParam(required = false) String customDetails,
            HttpSession session,
            RedirectAttributes redirectAttributes
    ) {
        User currentUser = getCurrentUser(session);
        if (currentUser == null) return "redirect:/login";

        if (durationMinutes <= 0 || caloriesBurned <= 0) {
            redirectAttributes.addFlashAttribute("error", "Duration and calories burned must be positive values.");
            return "redirect:/dashboard";
        }
        
        // Create the new activity object
        FitnessActivity newActivity = new FitnessActivity(
            currentUser, 
            activityType, 
            durationMinutes, 
            caloriesBurned, 
            customDetails != null ? customDetails : "No specific notes."
        );
        
        // Service handles saving and triggering the Gemini recommendation
        FitnessActivity savedActivity = fitnessService.createActivityAndGetRecommendation(newActivity);

        redirectAttributes.addFlashAttribute("message", "Activity logged. AI recommendation is being generated.");
        return "redirect:/activity/" + savedActivity.getId();
    }
    
    // Profile Management
    
    @GetMapping("/profile")
    public String showProfile(HttpSession session, Model model) {
        User currentUser = getCurrentUser(session);
        if (currentUser == null) return "redirect:/login";

        model.addAttribute("user", currentUser);
        return "profile"; 
    }
    
    @PostMapping("/profile/update")
    public String updateProfile(
            @RequestParam String firstName, 
            @RequestParam String lastName,
            @RequestParam String email,
            HttpSession session,
            RedirectAttributes redirectAttributes
    ) {
        User currentUser = getCurrentUser(session);
        if (currentUser == null) return "redirect:/login";

        Optional<User> updatedUserOpt = userService.updateProfile(currentUser.getId(), firstName, lastName, email);
            
        if (updatedUserOpt.isPresent()) {
            // Update session with fresh user data
            session.setAttribute("currentUser", updatedUserOpt.get());
            redirectAttributes.addFlashAttribute("message", "Profile updated successfully!");
        } else {
            redirectAttributes.addFlashAttribute("error", "Could not update profile. Email might be in use or data was invalid.");
        }
        
        return "redirect:/profile";
    }

    // Password Update
    @PostMapping("/profile/password")
    public String updatePassword(
            @RequestParam String currentPassword,
            @RequestParam String newPassword,
            @RequestParam String confirmNewPassword,
            HttpSession session,
            RedirectAttributes redirectAttributes
    ) {
        User currentUser = getCurrentUser(session);
        if (currentUser == null) return "redirect:/login";

        // 1. Check if passwords match
        if (!newPassword.equals(confirmNewPassword)) {
            redirectAttributes.addFlashAttribute("error", "New passwords do not match.");
            return "redirect:/profile";
        }
        
        // 2. Apply Password Complexity Validation
        String passwordRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[@#$%^&+=!]).{8,16}$";
        
        if (!newPassword.matches(passwordRegex)) {
            redirectAttributes.addFlashAttribute("error", 
                "New password must be 8-16 characters long and contain at least one uppercase letter, one lowercase letter, one number, and one special character (@, #, $, !, etc.).");
            return "redirect:/profile";
        }

        // 3. Re-authenticate using current password
        if (!userService.getPasswordEncoder().matches(currentPassword, currentUser.getPassword())) {
            redirectAttributes.addFlashAttribute("error", "Current password is incorrect.");
            return "redirect:/profile";
        }
        
        // 4. Save new password
        userService.updateUserPassword(currentUser, newPassword);
        session.invalidate(); // Force re-login for security
        redirectAttributes.addFlashAttribute("message", "Password updated successfully. Please log in with your new password.");
        return "redirect:/login";
    }
    
    // Account Deletion
    @PostMapping("/account/delete")
    public String deleteAccount(
            @RequestParam(defaultValue = "false") boolean permanentlyDelete,
            HttpSession session,
            RedirectAttributes redirectAttributes
    ) {
        User currentUser = getCurrentUser(session);
        if (currentUser == null) return "redirect:/login";
        
        // Logic assumes the 'permanentlyDelete' flag is passed (which it is, hidden in the form).
        if (permanentlyDelete) {
             userService.deleteUser(currentUser.getId());
             session.invalidate();
             redirectAttributes.addFlashAttribute("message", "Your account and all associated fitness data have been permanently removed.");
             return "redirect:/login";
        }
        
        // If 'permanentlyDelete' was somehow false, just redirect back to profile with an error/warning
        redirectAttributes.addFlashAttribute("error", "Account deletion failed due to invalid confirmation.");
        return "redirect:/profile"; 
    }
}