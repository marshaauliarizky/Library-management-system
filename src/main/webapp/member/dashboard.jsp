<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Member Dashboard - Library Management System</title>
    <style>
        :root {
            --cream: #F3E9DC;
            --caramel: #C08552;
            --brownie: #5E3023;
            --coffee: #895737;
        }
        
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: Arial, sans-serif;
            background-color: var(--cream);
            display: flex;
            min-height: 100vh;
        }
        
        .sidebar {
            width: 250px;
            background-color: var(--caramel);
            color: white;
            padding: 20px 0;
            position: fixed;
            height: 100%;
        }
        
        .sidebar-header {
            display: flex;
            align-items: center;
            padding: 0 20px;
            margin-bottom: 30px;
        }
        
        .sidebar-logo {
            font-size: 24px;
            margin-right: 10px;
        }
        
        .sidebar-title {
            font-size: 18px;
            font-weight: bold;
        }
        
        .sidebar-menu {
            list-style: none;
        }
        
        .sidebar-menu li {
            margin-bottom: 5px;
        }
        
        .sidebar-menu li a {
            color: white;
            text-decoration: none;
            display: block;
            padding: 12px 20px;
            transition: background-color 0.3s;
        }
        
        .sidebar-menu li a:hover,
        .sidebar-menu li a.active {
            background-color: var(--coffee);
        }
        
        .main-content {
            flex: 1;
            padding: 30px;
            margin-left: 250px;
        }
        
        .welcome-card {
            background-color: white;
            border-radius: 8px;
            padding: 30px;
            margin-bottom: 30px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.05);
        }
        
        .welcome-title {
            color: var(--brownie);
            font-size: 24px;
            margin-bottom: 10px;
        }
        
        .welcome-text {
            color: #333;
            margin-bottom: 20px;
        }
        
        .stats-container {
            display: flex;
            gap: 20px;
            margin-bottom: 30px;
        }
        
        .stat-card {
            flex: 1;
            background-color: white;
            border-radius: 8px;
            padding: 20px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.05);
            transition: transform 0.3s;
        }
        
        .stat-card:hover {
            transform: translateY(-5px);
        }
        
        .stat-icon {
            font-size: 30px;
            color: var(--caramel);
            margin-bottom: 15px;
        }
        
        .stat-title {
            font-size: 18px;
            color: var(--brownie);
            margin-bottom: 10px;
        }
        
        .stat-value {
            font-size: 28px;
            font-weight: bold;
            color: #333;
        }
        
        .search-bar {
            width: 100%;
            margin-bottom: 30px;
            position: relative;
        }
        
        .search-input {
            width: 100%;
            padding: 12px 20px;
            border: 1px solid #ddd;
            border-radius: 8px;
            font-size: 16px;
            outline: none;
        }
        
        .section-title {
            color: var(--brownie);
            margin-bottom: 20px;
            font-size: 20px;
        }
        
        .recent-books {
            background-color: white;
            border-radius: 8px;
            padding: 20px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.05);
        }
        
        .books-table {
            width: 100%;
            border-collapse: collapse;
        }
        
        .books-table th {
            text-align: left;
            padding: 12px;
            background-color: var(--cream);
            color: var(--brownie);
        }
        
        .books-table td {
            padding: 12px;
            border-bottom: 1px solid #f0f0f0;
        }
        
        .books-table tr:last-child td {
            border-bottom: none;
        }
        
        .books-table tr:nth-child(even) {
            background-color: #fdfdfd;
        }
        
        .status-badge {
            display: inline-block;
            padding: 3px 8px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: bold;
        }
        
        .on-time {
            background-color: #2ecc71;
            color: white;
        }
        
        .overdue {
            background-color: #e74c3c;
            color: white;
        }
        
        .btn {
            padding: 8px 16px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 14px;
            font-weight: bold;
            text-decoration: none;
            transition: background-color 0.3s;
        }
        
        .btn-primary {
            background-color: var(--caramel);
            color: white;
        }
        
        .btn-primary:hover {
            background-color: #a6723f;
        }
        
        .alert {
            padding: 15px;
            border-radius: 4px;
            margin-bottom: 20px;
        }
        
        .alert-success {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        
        .alert-danger {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
        
        @media (max-width: 768px) {
            .sidebar {
                width: 70px;
                overflow: hidden;
            }
            
            .sidebar-title {
                display: none;
            }
            
            .main-content {
                margin-left: 70px;
            }
            
            .stats-container {
                flex-direction: column;
            }
        }
    </style>
</head>
<body>
    <div class="sidebar">
        <div class="sidebar-header">
            <div class="sidebar-logo">📚</div>
            <div class="sidebar-title">Library Member</div>
        </div>
        <ul class="sidebar-menu">
            <li><a href="${pageContext.request.contextPath}/member/dashboard" class="active">Dashboard</a></li>
            <li><a href="${pageContext.request.contextPath}/member/books">Browse Books</a></li>
            <li><a href="${pageContext.request.contextPath}/member/issued-books">My Borrowed Books</a></li>
            <li><a href="${pageContext.request.contextPath}/member/history">My History</a></li>
            <li><a href="${pageContext.request.contextPath}/member/profile">My Profile</a></li>
            <li><a href="${pageContext.request.contextPath}/logout">Logout</a></li>
        </ul>
    </div>
    
    <div class="main-content">
        <c:if test="${not empty successMessage}">
            <div class="alert alert-success">
                ${successMessage}
            </div>
        </c:if>
        
        <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger">
                ${errorMessage}
            </div>
        </c:if>
        
        <div class="welcome-card">
            <h1 class="welcome-title">Welcome, ${sessionScope.memberUser.name}!</h1>
            <p class="welcome-text">Browse our collection, check your borrowed books, or update your profile information.</p>
        </div>
        
        <div class="stats-container">
            <div class="stat-card">
                <div class="stat-icon">📖</div>
                <div class="stat-title">Currently Borrowed</div>
                <div class="stat-value">${currentlyBorrowed}</div>
            </div>
            <div class="stat-card">
                <div class="stat-icon">🔄</div>
                <div class="stat-title">Total Borrowed</div>
                <div class="stat-value">${totalBorrowed}</div>
            </div>
            <div class="stat-card">
                <div class="stat-icon">⌛</div>
                <div class="stat-title">Overdue Books</div>
                <div class="stat-value">${overdueBooks}</div>
            </div>
        </div>
        
        <div class="search-bar">
            <input type="text" class="search-input" placeholder="Search for books...">
        </div>
        
        <div class="recent-books">
            <h2 class="section-title">Currently Borrowed Books</h2>
            <table class="books-table">
                <thead>
                    <tr>
                        <th>Book Title</th>
                        <th>Issued Date</th>
                        <th>Due Date</th>
                        <th>Status</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="book" items="${currentlyBorrowedBooks}">
                        <tr>
                            <td>${book.bookTitle}</td>
                            <td><fmt:formatDate value="${book.dateIssued}" pattern="yyyy-MM-dd" /></td>
                            <td><fmt:formatDate value="${book.dueDate}" pattern="yyyy-MM-dd" /></td>
                            <td>
                                <c:choose>
                                    <c:when test="${book.dueDate.time lt now.time}">
                                        <span class="status-badge overdue">OVERDUE</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="status-badge on-time">ON TIME</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
<c:if test="${book.returnStatus == 'NOT_RETURNED' && book.extensionStatus == 'NONE'}">
    <form action="${pageContext.request.contextPath}/member/request-extension" method="post" class="extension-form">
        <input type="hidden" name="action" value="requestExtension">
        <input type="hidden" name="issuedBookId" value="${book.id}">
        <button type="submit" class="btn btn-primary btn-sm">Request Extension</button>
    </form>
</c:if>
                                
                                                             
<c:if test="${book.returnStatus == 'NOT_RETURNED' && book.extensionStatus != 'NONE'}">
    <c:choose>
        <c:when test="${book.extensionStatus == 'REQUESTED'}">
            <span class="info-message">Extension request is being processed.</span>
        </c:when>
        <c:when test="${book.extensionStatus == 'APPROVED'}">
            <span class="info-message success">Extension has been approved.</span>
        </c:when>
        <c:when test="${book.extensionStatus == 'REJECTED'}">
            <span class="info-message error">Extension request was rejected.</span>
        </c:when>
    </c:choose>
</c:if>
                            </td>
                        </tr>
                    </c:forEach>
                    
                    <!-- Sample data if no data available -->
                    <c:if test="${empty currentlyBorrowedBooks}">
                        <tr>
                            <td colspan="5" style="text-align: center; padding: 20px;">You have no borrowed books at the moment.</td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </div>
    
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Initialize search functionality
            const searchInput = document.querySelector('.search-input');
            searchInput.addEventListener('keypress', function(e) {
                if (e.key === 'Enter') {
                    const searchTerm = this.value.trim();
                    if (searchTerm) {
                        window.location.href = '${pageContext.request.contextPath}/member/books?search=' + encodeURIComponent(searchTerm);
                    }
                }
            });
            
            // Add event listeners to prevent double submission
            document.querySelectorAll('.extension-form').forEach(form => {
                form.addEventListener('submit', function(e) {
                    // Disable the submit button to prevent double-clicking
                    const submitButton = this.querySelector('button[type="submit"]');
                    if (submitButton) {
                        submitButton.disabled = true;
                        submitButton.textContent = 'Processing...';
                    }
                });
            });
        });
    </script>
</body>
</html>