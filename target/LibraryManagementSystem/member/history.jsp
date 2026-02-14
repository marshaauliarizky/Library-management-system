<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My History - Library Management System</title>
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
        
        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
        }
        
        .page-title {
            color: var(--brownie);
            font-size: 24px;
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
        
        .section-title {
            color: var(--brownie);
            font-size: 20px;
            margin-bottom: 20px;
        }
        
        .stats-container {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        
        .stat-card {
            background-color: white;
            border-radius: 8px;
            padding: 20px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.05);
            text-align: center;
        }
        
        .stat-title {
            color: var(--brownie);
            font-size: 16px;
            margin-bottom: 10px;
        }
        
        .stat-value {
            font-size: 24px;
            font-weight: bold;
            color: var(--caramel);
        }
        
        .history-section {
            background-color: white;
            border-radius: 8px;
            padding: 20px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.05);
            margin-bottom: 30px;
        }
        
        .history-table {
            width: 100%;
            border-collapse: collapse;
        }
        
        .history-table th {
            text-align: left;
            padding: 12px;
            background-color: var(--cream);
            color: var(--brownie);
        }
        
        .history-table td {
            padding: 12px;
            border-bottom: 1px solid #f0f0f0;
        }
        
        .history-table tr:last-child td {
            border-bottom: none;
        }
        
        .history-table tr:nth-child(even) {
            background-color: #fdfdfd;
        }
        
        .categories-section {
            background-color: white;
            border-radius: 8px;
            padding: 20px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.05);
        }
        
        .categories-container {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
            gap: 20px;
        }
        
        .category-card {
            background-color: var(--cream);
            border-radius: 8px;
            padding: 15px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
        }
        
        .category-name {
            color: var(--brownie);
            font-weight: bold;
            margin-bottom: 10px;
        }
        
        .category-count {
            color: var(--caramel);
            font-size: 18px;
            font-weight: bold;
        }
        
        .category-last-borrowed {
            font-size: 12px;
            color: #666;
            margin-top: 5px;
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
        
        .returned {
            background-color: #3498db;
            color: white;
        }
        
        .not-returned {
            background-color: #f39c12;
            color: white;
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
            
            .stats-container,
            .categories-container {
                grid-template-columns: 1fr;
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
            <li><a href="${pageContext.request.contextPath}/member/dashboard">Dashboard</a></li>
            <li><a href="${pageContext.request.contextPath}/member/books">Browse Books</a></li>
            <li><a href="${pageContext.request.contextPath}/member/issued-books">My Borrowed Books</a></li>
            <li><a href="${pageContext.request.contextPath}/member/history" class="active">My History</a></li>
            <li><a href="${pageContext.request.contextPath}/member/profile">My Profile</a></li>
            <li><a href="${pageContext.request.contextPath}/logout">Logout</a></li>
        </ul>
    </div>
    
    <div class="main-content">
        <div class="header">
            <h1 class="page-title">My Borrowing History</h1>
        </div>
        
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
        
        <div class="stats-container">
            <div class="stat-card">
                <div class="stat-title">Total Borrowed</div>
                <div class="stat-value">${totalBorrowed}</div>
            </div>
            <div class="stat-card">
                <div class="stat-title">Currently Borrowed</div>
                <div class="stat-value">${currentlyBorrowed}</div>
            </div>
            <div class="stat-card">
                <div class="stat-title">On-time Returns</div>
                <div class="stat-value">${onTimeReturns}</div>
            </div>
            <div class="stat-card">
                <div class="stat-title">Late Returns</div>
                <div class="stat-value">${lateReturns}</div>
            </div>
        </div>
        
        <div class="history-section">
            <h2 class="section-title">Recent Activity</h2>
            
            <c:choose>
                <c:when test="${empty recentActivity}">
                    <p>You haven't borrowed any books yet.</p>
                </c:when>
                <c:otherwise>
                    <table class="history-table">
                        <thead>
                            <tr>
                                <th>Book Title</th>
                                <th>Issue Date</th>
                                <th>Due Date</th>
                                <th>Return Date</th>
                                <th>Status</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="book" items="${recentActivity}">
                                <tr>
                                    <td>${book.bookTitle}</td>
                                    <td><fmt:formatDate value="${book.dateIssued}" pattern="yyyy-MM-dd" /></td>
                                    <td><fmt:formatDate value="${book.dueDate}" pattern="yyyy-MM-dd" /></td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${book.dateReturned != null}">
                                                <fmt:formatDate value="${book.dateReturned}" pattern="yyyy-MM-dd" />
                                            </c:when>
                                            <c:otherwise>-</c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${book.returnStatus == 'RETURNED'}">
                                                <span class="status-badge returned">RETURNED</span>
                                            </c:when>
                                            <c:otherwise>
                                                <c:choose>
                                                    <c:when test="${book.dueDate.time lt now.time}">
                                                        <span class="status-badge overdue">OVERDUE</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="status-badge not-returned">BORROWED</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:otherwise>
            </c:choose>
        </div>
        
        <div class="categories-section">
            <h2 class="section-title">Most Borrowed Categories</h2>
            
            <c:choose>
                <c:when test="${empty borrowedCategories}">
                    <p>No category data available yet.</p>
                </c:when>
                <c:otherwise>
                    <div class="categories-container">
                        <c:forEach var="category" items="${borrowedCategories}">
                            <div class="category-card">
                                <div class="category-name">${category.name}</div>
                                <div class="category-count">${category.count} books</div>
                                <div class="category-last-borrowed">
                                    Last borrowed: <fmt:formatDate value="${category.lastBorrowed}" pattern="yyyy-MM-dd" />
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</body>
</html>