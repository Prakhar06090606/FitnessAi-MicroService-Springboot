<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Activity Details | FitTrack</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Inter:wght@400;700;800&display=swap');
        body { font-family: 'Inter', sans-serif; background-color: #f8f9fa; }
        .ai-recommendation { white-space: pre-wrap; }
    </style>
</head>
<body class="bg-light min-vh-100">

<!-- Navbar -->
<nav class="navbar navbar-expand-lg navbar-dark bg-primary shadow-lg">
    <div class="container-fluid container-max-width px-4 h-16 flex items-center">
        <a class="navbar-brand text-white fw-bold fs-4" href="${pageContext.request.contextPath}/dashboard">FitTrack</a>
    </div>
</nav>

<div class="container max-w-4xl py-5">

    <h1 class="text-3xl fw-bold text-gray-800 mb-4">Activity Details</h1>

    <div class="card p-5 rounded-xl shadow-xl space-y-4">
        
        <!-- Activity Summary -->
        <div class="border-bottom pb-3">
            <span class="text-4xl fw-bolder text-primary d-block">${activity.activityType}</span>
            <p class="text-secondary mt-1 small">Logged on: ${activity.activityDate}</p>
        </div>

        <div class="row g-3">
            <div class="col-md-6">
                <div class="bg-light p-4 rounded-lg border border-gray-300">
                    <p class="text-sm font-medium text-muted mb-1">Duration</p>
                    <p class="text-xl fw-bold text-gray-800">${activity.durationMinutes} minutes</p>
                </div>
            </div>
            <div class="col-md-6">
                <div class="bg-light p-4 rounded-lg border border-gray-300">
                    <p class="text-sm font-medium text-muted mb-1">Calories Burned</p>
                    <p class="text-xl fw-bold text-gray-800">${activity.caloriesBurned} kcal</p>
                </div>
            </div>
        </div>

        <!-- Custom Notes -->
        <div>
            <h3 class="fs-5 fw-semibold text-gray-700 mb-2">User Notes</h3>
            <p class="bg-light p-4 rounded-lg text-gray-600 border border-gray-300">${activity.customDetails}</p>
        </div>
        
        <!-- Gemini Recommendation -->
        <div class="pt-4 border-top border-success-subtle">
            <h3 class="fs-5 fw-semibold text-success mb-3 d-flex align-items-center">
                <i class="bi bi-robot me-2"></i> AI Coach Tip for ${activity.activityType}
            </h3>
            <div class="bg-success-subtle border border-success p-4 rounded-lg shadow-inner">
                <p class="text-gray-700 ai-recommendation mb-0">
                    <c:choose>
                        <c:when test="${not empty activity.geminiRecommendation}">
                            <c:out value="${activity.geminiRecommendation}"/>
                        </c:when>
                        <c:otherwise>
                            The AI recommendation is still being processed or failed to generate.
                        </c:otherwise>
                    </c:choose>
                </p>
            </div>
        </div>

    </div>
    
    <div class="mt-4 text-center">
        <a href="${pageContext.request.contextPath}/${sessionScope.role eq 'ROLE_ADMIN' ? 'admin/dashboard' : 'dashboard'}" 
           class="btn btn-primary fw-medium shadow-sm">
           <i class="bi bi-arrow-left me-1"></i> Back to Dashboard
        </a>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>