package com.example.demo.service;

import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.time.Duration;
import java.util.Map;
import java.util.List;

import org.springframework.stereotype.Service;

import com.fasterxml.jackson.databind.ObjectMapper;

// Handles communication with the Gemini API to generate fitness recommendations.

@Service
public class GeminiService {

    // IMPORTANT: Replace this with your actual Gemini API Key from Google AI Studio.
    private static final String API_KEY = "Enter your api key"; 
    private static final String MODEL_NAME = "gemini-2.5-flash-preview-05-20";
    private static final String API_URL = "https://generativelanguage.googleapis.com/v1beta/models/" + MODEL_NAME + ":generateContent?key=" + API_KEY;

    private final HttpClient httpClient = HttpClient.newBuilder()
            .version(HttpClient.Version.HTTP_2)
            .connectTimeout(Duration.ofSeconds(10))
            .build();
    
    private final ObjectMapper objectMapper = new ObjectMapper();

    /**
     * Generates a fitness recommendation based on the provided user activity prompt.
     * This method is called by FitnessService.
     * * @param userPrompt The detailed text prompt containing activity data.
     * @return The AI-generated recommendation string, or an error message.
     */
    public String generateRecommendation(String userPrompt) {
        
        // Define the System Instruction
        String systemInstruction = "Act as a professional, motivating fitness and nutrition coach. Your response must be concise and actionable, limited to three sentences.";

        // Construct the JSON payload for the Gemini API
        String jsonPayload;
        try {
            jsonPayload = objectMapper.writeValueAsString(Map.of(
                "contents", List.of(Map.of("parts", List.of(Map.of("text", userPrompt)))),
                "systemInstruction", Map.of("parts", List.of(Map.of("text", systemInstruction)))
            ));
        } catch (Exception e) {
            return "Error: Could not format AI request payload.";
        }

        // Build the HTTP Request
        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create(API_URL))
                .header("Content-Type", "application/json")
                .POST(HttpRequest.BodyPublishers.ofString(jsonPayload))
                .build();

        try {
            // Send the request and get the response
            HttpResponse<String> response = httpClient.send(request, HttpResponse.BodyHandlers.ofString());

            if (response.statusCode() == 200) {
                // Parse the successful response
                Map<?, ?> result = objectMapper.readValue(response.body(), Map.class);
                
                // Navigate the nested JSON structure to extract the generated text
                List<Map<?, ?>> candidates = (List<Map<?, ?>>) result.get("candidates");
                if (candidates != null && !candidates.isEmpty()) {
                    Map<?, ?> content = (Map<?, ?>) candidates.get(0).get("content");
                    List<Map<?, ?>> parts = (List<Map<?, ?>>) content.get("parts");
                    if (parts != null && !parts.isEmpty()) {
                        return (String) parts.get(0).get("text");
                    }
                }
                return "AI Recommendation: (No text generated)";
            } 
            
            else {
                // Handle API error status codes
                System.err.println("Gemini API Error Status: " + response.statusCode() + " | Body: " + response.body());
                return "AI failed to respond. Status: " + response.statusCode();
            }

        } 
        
        catch (Exception e) {
            System.err.println("HTTP Request Failed: " + e.getMessage());
            return "AI Recommendation service is currently unavailable. Please check API key/connection.";
        }
    }
}