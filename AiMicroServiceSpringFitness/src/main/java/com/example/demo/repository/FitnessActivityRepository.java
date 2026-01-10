package com.example.demo.repository;

import com.example.demo.model.FitnessActivity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface FitnessActivityRepository extends JpaRepository<FitnessActivity, Long> {
    // Fetch activities for a specific user, sorted by date (newest first)
    List<FitnessActivity> findByUserIdOrderByActivityDateDesc(Long userId);
}