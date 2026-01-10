<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Reset Password | Fitness Tracker</title>
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
        <h2 class="h3 fw-bold text-warning">Set New Password</h2>
        <p class="text-secondary mt-2">Enter your new password below.</p>
    </div>

    <c:if test="${not empty error}">
        <div class="alert alert-danger rounded-3 mb-4">${error}</div>
    </c:if>

    <p class="text-center text-muted small">For: <strong>${email}</strong></p>

    <form method="post" action="${pageContext.request.contextPath}/reset-password">
        <!-- Hidden fields for context -->
        <input type="hidden" name="email" value="${email}">
        <input type="hidden" name="token" value="${token}">
        
        <!-- New Password -->
        <div class="mb-3">
            <label for="newPassword" class="form-label small fw-bold">New Password (Min 8 chars)</label>
            <input type="password" id="newPassword" name="newPassword" minlength="8" required 
                   class="form-control rounded-pill" aria-label="New Password">
        </div>
        
        <!-- Confirm New Password -->
        <div class="mb-4">
            <label for="confirmNewPassword" class="form-label small fw-bold">Confirm Password</label>
            <input type="password" id="confirmNewPassword" name="confirmNewPassword" required 
                   class="form-control rounded-pill" aria-label="Confirm New Password">
        </div>

        <!-- Reset Button -->
        <div class="d-grid">
            <button type="submit" 
                    class="btn btn-warning text-white w-100 rounded-pill fw-semibold shadow-sm">
                Reset Password
            </button>
        </div>
    </form>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>