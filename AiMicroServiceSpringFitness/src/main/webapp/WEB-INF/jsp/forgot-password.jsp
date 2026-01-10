<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Forgot Password | Fitness Tracker</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
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
        <h2 class="h3 fw-bold text-warning">Password Reset</h2>
        <p class="text-secondary mt-2">Enter your email to receive a reset link.</p>
    </div>

    <c:if test="${not empty error}">
        <div class="alert alert-danger rounded-3 mb-4">${error}</div>
    </c:if>
    <c:if test="${not empty message}">
        <div class="alert alert-success rounded-3 mb-4">${message}</div>
    </c:if>

    <form method="post" action="${pageContext.request.contextPath}/forgot-password">
        <!-- Email -->
        <div class="mb-4">
            <label for="email" class="form-label small fw-bold">Email Address</label>
            <input type="email" id="email" name="email" placeholder="you@example.com" required 
                   class="form-control rounded-pill" aria-label="Email">
        </div>
        
        <!-- Send Link Button -->
        <div class="d-grid">
            <button type="submit" 
                    class="btn btn-warning text-white w-100 rounded-pill fw-semibold shadow-sm">
                Send Reset Link
            </button>
        </div>
    </form>
    
    <div class="mt-4 text-center small">
        <a href="${pageContext.request.contextPath}/login" class="text-decoration-none text-primary">Back to Login</a>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>