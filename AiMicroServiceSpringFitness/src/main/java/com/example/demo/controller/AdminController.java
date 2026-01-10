package com.example.demo.controller;

import com.example.demo.model.FitnessActivity;
import com.example.demo.model.User;
import com.example.demo.service.FitnessService;
import com.example.demo.service.UserService;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;
import java.util.Optional;

@Controller
@RequestMapping("/admin")
public class AdminController {

    private final UserService userService;
    private final FitnessService fitnessService;

    public AdminController(UserService userService, FitnessService fitnessService) {
        this.userService = userService;
        this.fitnessService = fitnessService;
    }

    // Helper method to check if the current session belongs to an Admin.
    private boolean isAdmin(HttpSession session) {
        // Simple check to verify the role attribute
        return "ROLE_ADMIN".equals(session.getAttribute("role"));
    }

    // Admin Dashboard View
    
    @GetMapping("/dashboard")
    public String showDashboard(HttpSession session, Model model) {
        // Primary security check: Only allow access if the role is ADMIN.
        if (!isAdmin(session)) {
            // Non-admin or unauthenticated user hits this; redirect to login.
            return "redirect:/login"; 
        }

        User adminUser = (User) session.getAttribute("currentUser");
        
        // Fetch all regular users for the management panel
        List<User> regularUsers = userService.getAllNonAdminUsers();
        
        // Fetch ALL logged activities from ALL users
        List<FitnessActivity> allActivities = fitnessService.getAllActivities();
        
        model.addAttribute("admin", adminUser);
        model.addAttribute("users", regularUsers);
        model.addAttribute("activities", allActivities); // Pass ALL activities
        model.addAttribute("totalUsers", regularUsers.size());
        
        return "admin-dashboard";
    }

    // View Any User's Activity Details (Admin Override)
    @GetMapping("/activity/{id}")
    public String showActivityDetails(@PathVariable Long id, HttpSession session, Model model, RedirectAttributes redirectAttributes) {
        if (!isAdmin(session)) return "redirect:/login";

        Optional<FitnessActivity> activityOpt = fitnessService.getActivityById(id);
        
        if (activityOpt.isEmpty()) {
            redirectAttributes.addFlashAttribute("error", "Activity not found.");
            return "redirect:/admin/dashboard";
        }
        
        model.addAttribute("activity", activityOpt.get());
        // Indicate to the JSP that the view is accessed via Admin path for correct navigation link
        model.addAttribute("role", "ROLE_ADMIN"); 
        return "activity-details"; 
    }
    
    // Admin Action: Toggle User Status
    @PostMapping("/toggle-user/{id}")
    public String toggleUserEnabled(@PathVariable Long id, HttpSession session, RedirectAttributes redirectAttributes) {
        if (!isAdmin(session)) return "redirect:/login";

        try {
            userService.toggleUserEnabled(id);
            redirectAttributes.addFlashAttribute("message", "User account status updated successfully.");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Could not change user status.");
        }
        return "redirect:/admin/dashboard";
    }
    
    // Admin Action: Delete Activity
    @PostMapping("/activity/delete/{id}")
    public String deleteActivity(@PathVariable Long id, HttpSession session, RedirectAttributes redirectAttributes) {
        if (!isAdmin(session)) return "redirect:/login";

        try {
            // Assumes fitnessService.deleteActivity(id) exists
            fitnessService.deleteActivity(id);
            redirectAttributes.addFlashAttribute("message", "Activity ID " + id + " deleted successfully.");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Could not delete activity: " + e.getMessage());
        }
        return "redirect:/admin/dashboard";
    }
}