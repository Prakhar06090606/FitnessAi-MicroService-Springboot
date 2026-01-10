<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Sign Up | Fitness Tracker</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Inter:wght@400;700;800&display=swap');
        body { 
            font-family: 'Inter', sans-serif; 
            background-color: #f8f9fa;
        }
        .card-container {
            max-width: 550px;
            width: 100%;
        }
    </style>
</head>
<body class="bg-light d-flex justify-content-center align-items-center min-vh-100 p-4">

<div class="card card-container bg-white p-5 rounded-3 shadow-lg">
    <div class="text-center mb-4">
        <h2 class="h3 fw-bold text-success">Join FitTrack</h2>
        <p class="text-secondary mt-1">Start logging your fitness journey today.</p>
    </div>

    <c:if test="${not empty error}">
        <div class="alert alert-danger rounded-3 mb-4">${error}</div>
    </c:if>

    <form method="post" action="${pageContext.request.contextPath}/register">
        <div class="row g-3">
            
            <!-- First Name -->
            <div class="col-md-6">
                <label for="firstName" class="form-label small fw-bold">First Name</label>
                <input type="text" id="firstName" name="firstName" required
                       class="form-control rounded-pill">
            </div>
            
            <!-- Last Name -->
            <div class="col-md-6">
                <label for="lastName" class="form-label small fw-bold">Last Name</label>
                <input type="text" id="lastName" name="lastName" required
                       class="form-control rounded-pill">
            </div>

            <!-- Email (Username) -->
            <div class="col-12">
                <label for="email" class="form-label small fw-bold">Email Address</label>
                <input type="email" id="email" name="email" placeholder="you@example.com" required
                       class="form-control rounded-pill">
            </div>
            
            <!-- Password -->
            <div class="col-md-6">
                <label for="password" class="form-label small fw-bold">Password (Min 8 chars)</label>
                <input type="password" id="password" name="password" minlength="8" required
                       class="form-control rounded-pill">
            </div>

            <!-- Confirm Password -->
            <div class="col-md-6">
                <label for="confirmPassword" class="form-label small fw-bold">Confirm Password</label>
                <input type="password" id="confirmPassword" name="confirmPassword" required
                       class="form-control rounded-pill">
            </div>
        </div>

        <!-- Register Button -->
        <div class="d-grid mt-4">
            <button type="submit" 
                    class="btn btn-success w-100 rounded-pill fw-semibold shadow-md">
                Sign Up
            </button>
        </div>
    </form>

    <div class="mt-4 text-center small">
        <a href="${pageContext.request.contextPath}/login" class="text-decoration-none text-success">Already have an account? Log In</a>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>