<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Dashboard | FitTrack</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Inter:wght@400;700;800&display=swap');
        body { font-family: 'Inter', sans-serif; background-color: #f0f2f5; }
        .card { border-radius: 1rem; border: none; transition: transform 0.2s; }
        .card:hover { transform: translateY(-3px); }
        .btn-primary { background-color: #28a745; border-color: #28a745; }
        .btn-primary:hover { background-color: #1e7e34; border-color: #1c7430; }
        .admin-link { background-color: #dc3545; border-color: #dc3545; color: white; }
        .admin-link:hover { background-color: #c82333; border-color: #bd2130; color: white; }
    </style>
</head>
<body class="bg-light">

<!-- Navbar -->
<nav class="navbar navbar-expand-lg navbar-dark bg-dark shadow-sm">
    <div class="container">
        <a class="navbar-brand fw-bold" href="${pageContext.request.contextPath}/dashboard">
            <i class="bi bi-heart-pulse-fill me-1"></i> FitTrack
        </a>
        <div class="d-flex align-items-center">
             <span class="navbar-text me-3 text-white-50">
                Hello, <strong>${user.firstName}</strong>!
            </span>
            <a class="btn btn-outline-info me-2" href="${pageContext.request.contextPath}/profile">
                <i class="bi bi-person-fill"></i> Profile
            </a>
            <a class="btn btn-outline-danger" href="${pageContext.request.contextPath}/logout">
                <i class="bi bi-box-arrow-right"></i> Logout
            </a>
        </div>
    </div>
</nav>

<div class="container my-5">
    
    <!-- ADMIN PANEL BUTTON (Appears only for ROLE_ADMIN) -->
    <c:if test="${sessionScope.role eq 'ROLE_ADMIN'}">
        <a href="${pageContext.request.contextPath}/admin/dashboard" class="btn btn-lg admin-link w-100 mb-4 shadow-sm rounded-pill">
            <i class="bi bi-gear-fill me-2"></i> Go to Admin Panel
        </a>
    </c:if>
    
    <h1 class="text-dark fw-bolder mb-4 border-bottom pb-2">Your Fitness Dashboard</h1>

    <c:if test="${not empty message}">
        <div class="alert alert-success alert-dismissible fade show rounded-3 mb-4" role="alert">
            ${message}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    </c:if>
    <c:if test="${not empty error}">
        <div class="alert alert-danger alert-dismissible fade show rounded-3 mb-4" role="alert">
            ${error}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    </c:if>

    <div class="row">
        <!-- Left Column: Activity Log Form -->
        <div class="col-lg-4 mb-4">
            <div class="card p-4 shadow-lg bg-white h-100">
                <h3 class="card-title text-primary fw-bold mb-3">Log New Activity</h3>
                <form method="post" action="${pageContext.request.contextPath}/activity/new">
                    
                    <div class="mb-3">
                        <label for="activityType" class="form-label small fw-semibold">Activity Type</label>
                        <select class="form-select" id="activityType" name="activityType" required>
                            <option value="">Select Activity</option>
                            <c:forEach var="type" items="${activityTypes}">
                                <option value="${type}">${type}</option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="mb-3">
                        <label for="durationMinutes" class="form-label small fw-semibold">Duration (Minutes)</label>
                        <input type="number" class="form-control" id="durationMinutes" name="durationMinutes" min="1" required>
                    </div>

                    <div class="mb-3">
                        <label for="caloriesBurned" class="form-label small fw-semibold">Calories Burned (kcal)</label>
                        <input type="number" class="form-control" id="caloriesBurned" name="caloriesBurned" min="1" required>
                    </div>
                    
                    <div class="mb-4">
                        <label for="customDetails" class="form-label small fw-semibold">Notes/Details (Optional)</label>
                        <textarea class="form-control" id="customDetails" name="customDetails" rows="2" placeholder="e.g., Felt great, hill sprints, etc."></textarea>
                    </div>

                    <div class="d-grid">
                        <button type="submit" class="btn btn-primary btn-lg">Log Activity & Get AI Tip</button>
                    </div>
                </form>
            </div>
        </div>
        <!-- Right Column: Activity History -->
        <div class="col-lg-8">
            <div class="card p-4 shadow-lg bg-white">
                <h3 class="card-title text-dark fw-bold mb-3 border-bottom pb-2">Recent History</h3>
                <c:choose>
                    <c:when test="${fn:length(activities) == 0}">
                        <p class="text-center text-muted py-4">No activities logged yet. Start tracking your fitness journey!</p>
                    </c:when>
                    <c:otherwise>
                        <div class="list-group">
                            <c:forEach var="activity" items="${activities}">
                                <a href="${pageContext.request.contextPath}/activity/${activity.id}" class="list-group-item list-group-item-action mb-2 rounded-3">
                                    <div class="d-flex w-100 justify-content-between">
                                        <h5 class="mb-1 text-primary fw-semibold">${activity.activityType}</h5>
                                        <small class="text-muted">${activity.activityDate}</small>
                                    </div>
                                    <p class="mb-1">
                                        Duration: ${activity.durationMinutes} min &bull; Calories: ${activity.caloriesBurned} kcal
                                    </p>
                                    <small class="text-info">View AI Tip & Details &rarr;</small>
                                </a>
                            </c:forEach>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>