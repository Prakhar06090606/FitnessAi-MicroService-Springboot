<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Profile | Fitness Tracker</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.3/font/bootstrap-icons.min.css">
    <style>
        body { background-color: #f8f9fa; }
        .card { border-radius: 1rem; border: none; }
        .btn-primary { background-color: #28a745; border-color: #28a745; }
        .btn-primary:hover { background-color: #1e7e34; border-color: #1c7430; }
        .profile-header { border-bottom: 2px solid #28a745; }
        .btn-danger-custom { background-color: #dc3545; border-color: #dc3545; color: white; }
        .btn-danger-custom:hover { background-color: #c82333; border-color: #bd2130; color: white; }
    </style>
</head>
<body>

    <nav class="navbar navbar-expand-lg navbar-dark bg-dark shadow-sm">
        <div class="container">
            <a class="navbar-brand fw-bold" href="${pageContext.request.contextPath}/dashboard">
                <i class="bi bi-heart-pulse-fill me-1"></i> Fitness Tracker
            </a>
            <div class="d-flex align-items-center">
                 <span class="navbar-text me-3 text-white-50">
                    Hello, <strong>${user.firstName}</strong>!
                </span>
                <a class="btn btn-outline-info me-2" href="${pageContext.request.contextPath}/dashboard">
                    <i class="bi bi-house-door-fill"></i> Dashboard
                </a>
                <a class="btn btn-outline-danger" href="${pageContext.request.contextPath}/logout">
                    <i class="bi bi-box-arrow-right"></i> Logout
                </a>
            </div>
        </div>
    </nav>

    <div class="container my-5">
        <h1 class="profile-header pb-3 mb-4 text-dark"><i class="bi bi-person-circle me-2"></i> User Profile</h1>

        <c:if test="${not empty message}">
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                ${message}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                ${error}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>

        <div class="row justify-content-center">
            <div class="col-lg-10">
                <div class="card shadow-lg p-4">
                    
                    <div class="row">
                        <!-- Left Column: Personal Info Update -->
                        <div class="col-md-6 border-end">
                            <h4 class="card-title text-success mb-4">Update Personal Information</h4>
                            <form method="post" action="${pageContext.request.contextPath}/profile/update">
                                
                                <div class="mb-3">
                                    <label for="firstName" class="form-label fw-bold">First Name</label>
                                    <input type="text" class="form-control" id="firstName" name="firstName" value="${user.firstName}" required>
                                </div>
                                
                                <div class="mb-3">
                                    <label for="lastName" class="form-label fw-bold">Last Name</label>
                                    <input type="text" class="form-control" id="lastName" name="lastName" value="${user.lastName}" required>
                                </div>
                                
                                <div class="mb-4">
                                    <label for="email" class="form-label fw-bold">Email Address</label>
                                    <input type="email" class="form-control" id="email" name="email" value="${user.email}" required>
                                    <div class="form-text">Changing email requires it to be unique.</div>
                                </div>

                                <div class="d-grid mt-4">
                                    <button type="submit" class="btn btn-primary btn-lg">
                                        <i class="bi bi-save me-2"></i> Save Changes
                                    </button>
                                </div>
                            </form>
                        </div>
                        
                        <!-- Right Column: Password Update & Delete Account -->
                        <div class="col-md-6">
                            <h4 class="card-title text-warning mb-4 ps-md-4">Update Password</h4>
                            <p class="small text-muted ps-md-4">You must enter your current password. You will be logged out upon successful change.</p>
                            
                            <form method="post" action="${pageContext.request.contextPath}/profile/password" class="ps-md-4 mb-5">
                                <div class="mb-3">
                                    <label for="currentPassword" class="form-label fw-bold">Current Password</label>
                                    <input type="password" class="form-control" id="currentPassword" name="currentPassword" required>
                                </div>
                                <div class="mb-3">
                                    <label for="newPassword" class="form-label fw-bold">New Password (Min 8 chars)</label>
                                    <input type="password" class="form-control" id="newPassword" name="newPassword" minlength="8" required>
                                </div>
                                <div class="mb-4">
                                    <label for="confirmNewPassword" class="form-label fw-bold">Confirm New Password</label>
                                    <input type="password" class="form-control" id="confirmNewPassword" name="confirmNewPassword" required>
                                </div>
                                
                                <div class="d-grid mt-4">
                                    <button type="submit" class="btn btn-warning text-white btn-lg">
                                        <i class="bi bi-key-fill me-2"></i> Update Password
                                    </button>
                                </div>
                            </form>
                            
                            <!-- Account Control Section -->
                            <div class="ps-md-4 mt-5">
                                <h4 class="text-danger mb-3">Account Control</h4>
                                <button type="button" class="btn btn-danger-custom btn-lg w-100" 
                                        data-bs-toggle="modal" data-bs-target="#deleteAccountModal">
                                    <i class="bi bi-trash-fill me-2"></i> Permanently Delete Account
                                </button>
                            </div>
                        </div>
                    </div>
                    

                </div>
            </div>
        </div>
    </div>
    
    <!-- Delete Account Confirmation Modal -->
    <div class="modal fade" id="deleteAccountModal" tabindex="-1" aria-labelledby="deleteAccountModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header bg-danger text-white">
                    <h5 class="modal-title" id="deleteAccountModalLabel">Confirm Account Deletion</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <p class="fw-bold text-danger">
                        <i class="bi bi-exclamation-triangle-fill me-2"></i> WARNING: This action is irreversible.
                    </p>
                    <p>
                        All your data, including **all logged activities and profile information, will be permanently removed from the database**. Are you absolutely sure you want to proceed?
                    </p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <!-- Form submission handles the actual deletion -->
                    <form method="post" action="${pageContext.request.contextPath}/account/delete" class="d-inline">
                        <input type="hidden" name="permanentlyDelete" value="true">
                        <button type="submit" class="btn btn-danger-custom">Yes, Delete My Account</button>
                    </form>
                </div>
            </div>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>