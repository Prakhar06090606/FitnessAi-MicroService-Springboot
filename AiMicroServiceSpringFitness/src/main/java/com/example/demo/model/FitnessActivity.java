package com.example.demo.model;

import jakarta.persistence.*;
import org.hibernate.annotations.CreationTimestamp;
import java.time.LocalDateTime;

// Stores a user's fitness activity data and the Gemini recommendation.

@Entity
public class FitnessActivity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private ActivityType activityType;

    private int durationMinutes;
    private int caloriesBurned;
    
    @Column(length = 500) // Flexible text input for custom details
    private String customDetails; 

    @CreationTimestamp
    private LocalDateTime activityDate;
    
    @Column(length = 2000) // Stores the AI recommendation
    private String geminiRecommendation;

    // Constructors
    public FitnessActivity() {}
    public FitnessActivity(User user, ActivityType activityType, int durationMinutes, int caloriesBurned, String customDetails) {
        this.user = user;
        this.activityType = activityType;
        this.durationMinutes = durationMinutes;
        this.caloriesBurned = caloriesBurned;
        this.customDetails = customDetails;
    }

    // Getters and Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public User getUser() { return user; }
    public void setUser(User user) { this.user = user; }
    public ActivityType getActivityType() { return activityType; }
    public void setActivityType(ActivityType activityType) { this.activityType = activityType; }
    public int getDurationMinutes() { return durationMinutes; }
    public void setDurationMinutes(int durationMinutes) { this.durationMinutes = durationMinutes; }
    public int getCaloriesBurned() { return caloriesBurned; }
    public void setCaloriesBurned(int caloriesBurned) { this.caloriesBurned = caloriesBurned; }
    public String getCustomDetails() { return customDetails; }
    public void setCustomDetails(String customDetails) { this.customDetails = customDetails; }
    public LocalDateTime getActivityDate() { return activityDate; }
    public void setActivityDate(LocalDateTime activityDate) { this.activityDate = activityDate; }
    public String getGeminiRecommendation() { return geminiRecommendation; }
    public void setGeminiRecommendation(String geminiRecommendation) { this.geminiRecommendation = geminiRecommendation; }
}