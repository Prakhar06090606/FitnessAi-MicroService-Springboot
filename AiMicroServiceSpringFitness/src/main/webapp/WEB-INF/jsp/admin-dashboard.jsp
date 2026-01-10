<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Admin Dashboard | FitTrack</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Inter:wght@400;700;800&display=swap');
        body { font-family: 'Inter', sans-serif; background-color: #f8f9fa; }
        .min-vh-100 { min-height: 100vh; }
    </style>
</head>
<body class="bg-light min-vh-100">

<!-- Navbar -->
<nav class="navbar navbar-expand-lg navbar-dark bg-danger shadow-lg">
    <div class="container-fluid container-max-width px-4">
        <a class="navbar-brand text-white fw-bold fs-4" href="${pageContext.request.contextPath}/admin/dashboard">
            <i class="bi bi-shield-lock-fill me-2"></i>Admin Panel
        </a>
        <div class="d-flex align-items-center gap-2">
            <!-- 1. User View Button: Redirects Admin to the standard user dashboard -->
            <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-outline-light rounded-pill fw-semibold">
                <i class="bi bi-person-fill me-1"></i> User View
            </a>
            <!-- Logout Button -->
            <a href="${pageContext.request.contextPath}/logout" class="btn btn-light rounded-pill fw-semibold">
                <i class="bi bi-box-arrow-right me-1"></i> Logout
            </a>
        </div>
    </div>
</nav>

<div class="container max-w-7xl py-5">

    <h1 class="text-3xl fw-bold text-danger mb-4 border-bottom pb-2">System Overview</h1>

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

    <!-- Metrics -->
    <div class="row g-4 mb-5">
        <!-- Metric 1 -->
        <div class="col-md-4">
            <div class="card p-4 rounded-xl shadow-sm border-start border-5 border-danger">
                <p class="text-sm font-medium text-muted mb-1">Total Regular Users</p>
                <p class="text-3xl fw-bold text-gray-900">${totalUsers}</p>
            </div>
        </div>
        <!-- Metric 2 -->
        <div class="col-md-4">
            <div class="card p-4 rounded-xl shadow-sm border-start border-5 border-primary">
                <p class="text-sm font-medium text-muted mb-1">Total Logged Activities</p>
                <p class="text-3xl fw-bold text-gray-900">${fn:length(activities)}</p>
            </div>
        </div>
        <!-- Metric 3 -->
        <div class="col-md-4">
            <div class="card p-4 rounded-xl shadow-sm border-start border-5 border-warning">
                <p class="text-sm font-medium text-muted mb-1">System Health</p>
                <p class="fs-5 fw-bold text-success mt-1">Operational</p>
            </div>
        </div>
    </div>

    <!-- User Management Table -->
    <div class="card p-4 rounded-xl shadow-lg mb-5">
        <h2 class="fs-4 fw-semibold text-danger mb-4 border-bottom pb-2"><i class="bi bi-people-fill me-1"></i> User Management</h2>
        
        <div class="table-responsive">
            <table class="table table-striped table-hover align-middle">
                <thead class="table-light">
                    <tr>
                        <th class="small">ID</th>
                        <th class="small">Name</th>
                        <th class="small">Email</th>
                        <th class="small">Status</th>
                        <th class="small">Action</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="userItem" items="${users}">
                        <tr>
                            <td>${userItem.id}</td>
                            <td>${userItem.firstName} ${userItem.lastName}</td>
                            <td>${userItem.email}</td>
                            <td>
                                <span class="badge bg-${userItem.enabled ? 'success' : 'danger'} rounded-pill">
                                    ${userItem.enabled ? 'Active' : 'Disabled'}
                                </span>
                            </td>
                            <td>
                                <form method="post" action="${pageContext.request.contextPath}/admin/toggle-user/${userItem.id}">
                                    <button type="submit" 
                                            class="btn btn-sm btn-${userItem.enabled ? 'danger' : 'success'} rounded-pill"
                                            onclick="return confirm('Are you sure you want to ${userItem.enabled ? 'DEACTIVATE' : 'ACTIVATE'} user ${userItem.email}?');">
                                        ${userItem.enabled ? 'Deactivate' : 'Activate'}
                                    </button>
                                </form>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
    
    <!-- Admin Activity View -->
     <div class="card p-4 rounded-xl shadow-lg">
        <h2 class="fs-4 fw-semibold text-danger mb-4 border-bottom pb-2"><i class="bi bi-activity me-1"></i> All Logged Activities</h2>
        
        <c:choose>
            <c:when test="${fn:length(activities) == 0}">
                <p class="text-secondary text-center py-4">No activities have been logged across the system.</p>
            </c:when>
            <c:otherwise>
                <div class="list-group">
                    <c:forEach var="activity" items="${activities}">
                        <div class="list-group-item list-group-item-action rounded-3 mb-2 border border-gray-200">
                            <div class="d-flex w-100 justify-content-between align-items-center">
                                <div>
                                    <h5 class="mb-1 fw-semibold text-gray-800">${activity.activityType}</h5>
                                    <p class="mb-1 text-sm text-secondary">
                                        ${activity.durationMinutes} min • ${activity.caloriesBurned} kcal
                                    </p>
                                    <small class="text-muted">Logged by **${activity.user.email}** on: ${activity.activityDate}</small>
                                </div>
                                <div class="d-flex gap-2">
                                    <a href="${pageContext.request.contextPath}/admin/activity/${activity.id}" 
                                       class="btn btn-sm btn-info rounded-pill">
                                        <i class="bi bi-eye"></i> Details
                                    </a>
                                    <form method="post" action="${pageContext.request.contextPath}/admin/activity/delete/${activity.id}" 
                                          onsubmit="return confirm('Confirm deletion of Activity ID ${activity.id}?');">
                                        <button type="submit" class="btn btn-sm btn-danger rounded-pill">
                                            <i class="bi bi-trash"></i> Delete
                                        </button>
                                    </form>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>