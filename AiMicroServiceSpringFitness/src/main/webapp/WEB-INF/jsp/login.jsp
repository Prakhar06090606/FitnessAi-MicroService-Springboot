<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Login | Fitness Tracker</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <!-- Load Bootstrap 5.3 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Inter:wght@400;700;800&display=swap');
        body { 
            font-family: 'Inter', sans-serif; 
            background-color: #f8f9fa;
        }
        .card-container {
            max-width: 450px;
            width: 100%;
        }
    </style>
</head>
<body class="bg-light d-flex justify-content-center align-items-center min-vh-100">

<div class="card card-container bg-white p-5 rounded-3 shadow-lg">
    <div class="text-center mb-4">
        <h2 class="h2 fw-bold text-primary display-6">FitTrack 🏃‍♂️</h2>
        <p class="text-secondary mt-2">Log in to track your progress.</p>
    </div>

    <c:if test="${not empty error}">
        <div class="alert alert-danger rounded-3 mb-4">${error}</div>
    </c:if>
    <c:if test="${not empty message}">
        <div class="alert alert-success rounded-3 mb-4">${message}</div>
    </c:if>

    <form method="post" action="${pageContext.request.contextPath}/login">
        <!-- Email/Username -->
        <div class="mb-3">
            <label for="email" class="form-label small fw-bold">Email (Username)</label>
            
            <input type="email" id="email" name="email" placeholder="you@example.com" required 
                   class="form-control rounded-pill" aria-label="Email">
        </div>
        
        <!-- Password -->
        <div class="mb-4">
            <label for="password" class="form-label small fw-bold">Password</label>
            
            <input type="password" id="password" name="password" placeholder="••••••••" required 
                   class="form-control rounded-pill" aria-label="Password">
        </div>

        <!-- Login Button -->
        <div class="d-grid mb-3">
            <button type="submit" 
                    class="btn btn-primary w-100 rounded-pill fw-semibold shadow-sm">
                Log In
            </button>
        </div>
    </form>
    
    <div class="text-center small mt-2">
        <a href="${pageContext.request.contextPath}/forgot-password" class="text-decoration-none text-primary">Forgot Password?</a>
    </div>

    <div class="mt-4 pt-3 border-top text-center">
        <p class="text-muted mb-2">New here?</p>
        <a href="${pageContext.request.contextPath}/register" 
           class="btn btn-outline-success w-75 rounded-pill fw-semibold">
            Create Account
        </a>
    </div>
</div>

<!-- Load Bootstrap 5.3 JS Bundle -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>