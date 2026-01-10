package com.example.demo.service;

import com.example.demo.model.ActivityType;
import com.example.demo.model.FitnessActivity;
import com.example.demo.model.User;
import com.example.demo.repository.FitnessActivityRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Service
public class FitnessService {

    private final FitnessActivityRepository activityRepository;
    private final GeminiService geminiService;

    public FitnessService(FitnessActivityRepository activityRepository, GeminiService geminiService) {
        this.activityRepository = activityRepository;
        this.geminiService = geminiService;
    }

    // Core Logic

    @Transactional
    public FitnessActivity createActivityAndGetRecommendation(FitnessActivity activity) {
        // 1. Save the activity initially
        FitnessActivity savedActivity = activityRepository.save(activity);
        
        // 2. Build the detailed prompt
        String prompt = buildGeminiPrompt(savedActivity);
        
        // 3. Generate recommendation using Gemini
        String recommendation = geminiService.generateRecommendation(prompt); 
        
        // 4. Update the saved activity with the recommendation
        savedActivity.setGeminiRecommendation(recommendation);
        
        // 5. Save the final updated activity 
        return activityRepository.save(savedActivity);
    }
    
    // Constructs a detailed prompt for the Gemini model based on the logged activity.
     
    private String buildGeminiPrompt(FitnessActivity activity) {
        User user = activity.getUser();
        
        // Note: The ActivityType enum needs a getDisplayName() method, but for code completeness, 
        // we'll assume a clean toString() or use simple formatting.
        String activityName = activity.getActivityType() != null ? activity.getActivityType().toString() : "Unknown Activity";
        String userName = user != null ? user.getFirstName() : "User";
        
        return String.format(
            "Act as a professional fitness and nutrition coach. Analyze the following activity data and provide a concise (max 6 sentences) recommendation, tip, or nutritional suggestion tailored to this workout and the user's general goals. Focus on recovery, hydration, or improving the next session.\n\n" +
            "Activity Type: %s\n" +
            "Duration: %d minutes\n" +
            "Calories Burned: %d\n" +
            "User Details/Notes: %s\n" +
            "User Name: %s",
            activityName,
            activity.getDurationMinutes(),
            activity.getCaloriesBurned(),
            activity.getCustomDetails(),
            userName
        );
    }

    // Data Retrieval Methods

    public List<FitnessActivity> getUserActivities(Long userId) {
        return activityRepository.findByUserIdOrderByActivityDateDesc(userId);
    }

    public Optional<FitnessActivity> getActivityById(Long activityId) {
        return activityRepository.findById(activityId);
    }
    
    // Admin Controller Required Methods
    // Retrieves all fitness activities from all users. (Required by AdminController)
    public List<FitnessActivity> getAllActivities() {
        return activityRepository.findAll();
    }

    // Deletes a specific activity by ID. (Required by AdminController)
    @Transactional
    public void deleteActivity(Long id) {
        activityRepository.deleteById(id);
    }
}