package com.example.demo.service;

import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Service;

/**
 * Mocks an email service for welcome/reset emails.
 * Requires Spring Mail setup in application.properties.
 */
@Service
public class EmailService {

    // Using a mock sender since JavaMailSender requires config which is outside the scope
    // private final JavaMailSender mailSender;

    public EmailService(/*JavaMailSender mailSender*/) {
        // this.mailSender = mailSender;
    }

    public void sendEmail(String to, String subject, String text) {
        try {
            // In a real application, you would uncomment the following lines and use mailSender
            /* SimpleMailMessage message = new SimpleMailMessage();
            message.setFrom("no-reply@fitnesstracker.com");
            message.setTo(to);
            message.setSubject(subject);
            message.setText(text);
            mailSender.send(message);
            */
            
            System.out.println("📧 MOCK Email Sent:");
            System.out.println("To: " + to);
            System.out.println("Subject: " + subject);
            System.out.println("Body: " + text.substring(0, Math.min(text.length(), 100)) + "...");
            
        } catch (Exception e) {
            System.err.println("🚨 FAILED to send email to " + to + ". Check your application.properties email configuration!");
            e.printStackTrace();
        }
    }

    public void sendWelcomeEmail(String to, String name) {
        String subject = "👋 Welcome to the Fitness Tracker!";
        String text = "Dear " + name + ",\n\nYour account is ready! Time to start tracking your gains.\n\nHappy Fitness!";
        sendEmail(to, subject, text);
    }
    
    public void sendPasswordResetEmail(String to, String resetLink) {
        String subject = "🔑 Password Reset Request";
        String text = "You requested a password reset. Click the following link to reset your password:\n" + resetLink;
        sendEmail(to, subject, text);
    }
}