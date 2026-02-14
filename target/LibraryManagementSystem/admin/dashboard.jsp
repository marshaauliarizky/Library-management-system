<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - Library Management System</title>
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
            background-color: var(--brownie);
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
        
        .page-title {
            color: var(--brownie);
            margin-bottom: 30px;
            font-size: 24px;
        }
        
        .stats-container {
            display: flex;
            gap: 20px;
            margin-bottom: 30px;
        }
        
        .stat-card {
            flex: 1;
            background-color: var(--caramel);
            color: white;
            border-radius: 8px;
            padding: 20px;
            display: flex;
            flex-direction: column;
            align-items: center;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }
        
        .stat-title {
            font-size: 18px;
            margin-bottom: 10px;
        }
        
        .stat-value {
            font-size: 32px;
            font-weight: bold;
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
        
        .history-section {
            background-color: white;
            border-radius: 8px;
            padding: 20px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.05);
        }
        
        .section-title {
            color: var(--brownie);
            margin-bottom: 20px;
            font-size: 18px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .view-all {
            color: var(--caramel);
            font-size: 14px;
            text-decoration: none;
        }
        
        .view-all:hover {
            text-decoration: underline;
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
        
        .status-badge {
            display: inline-block;
            padding: 3px 8px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: bold;
        }
        
        .returned {
            background-color: #2ecc71;
            color: white;
        }
        
        .not-returned {
            background-color: #e74c3c;
            color: white;
        }
        
        .overdue {
            background-color: #e74c3c;
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
            <div class="sidebar-title">Library Admin</div>
        </div>
        <ul class="sidebar-menu">
            <li><a href="${pageContext.request.contextPath}/admin/dashboard" class="active">Dashboard</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/books">Books</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/members">Members</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/issued-books">Issued Books</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/return-books">Return Books</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/history">History</a></li>
            <li><a href="${pageContext.request.contextPath}/logout">Logout</a></li>
        </ul>
    </div>
    
    <div class="main-content">
        <h1 class="page-title">Dashboard</h1>
        
        <div class="stats-container">
            <div class="stat-card">
                <div class="stat-title">Total Books</div>
                <div class="stat-value">${totalBooks}</div>
            </div>
            <div class="stat-card">
                <div class="stat-title">Total Members</div>
                <div class="stat-value">${totalMembers}</div>
            </div>
            <div class="stat-card">
                <div class="stat-title">Borrowed Books</div>
                <div class="stat-value">${borrowedBooks}</div>
            </div>
        </div>
        
        <div class="search-bar">
            <input type="text" class="search-input" placeholder="Search book or member...">
        </div>
        
        <div class="history-section">
            <div class="section-title">
                <h2>Recent Library Activity</h2>
                <a href="${pageContext.request.contextPath}/admin/history" class="view-all">View All</a>
            </div>
            <table class="history-table">
                <thead>
                    <tr>
                        <th>Book</th>
                        <th>Member</th>
                        <th>Issue Date</th>
                        <th>Due Date</th>
                        <th>Return Date</th>
                        <th>Status</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="issuedBook" items="${recentActivityBooks}" end="4">
                        <tr>
                            <td>${issuedBook.bookTitle}</td>
                            <td>${issuedBook.memberName}</td>
                            <td><fmt:formatDate value="${issuedBook.dateIssued}" pattern="yyyy-MM-dd" /></td>
                            <td><fmt:formatDate value="${issuedBook.dueDate}" pattern="yyyy-MM-dd" /></td>
                            <td>
                                <c:choose>
                                    <c:when test="${issuedBook.dateReturned != null}">
                                        <fmt:formatDate value="${issuedBook.dateReturned}" pattern="yyyy-MM-dd" />
                                    </c:when>
                                    <c:otherwise>
                                        -
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${issuedBook.returnStatus == 'RETURNED'}">
                                        <span class="status-badge returned">RETURNED</span>
                                    </c:when>
                                    <c:when test="${issuedBook.dueDate.time lt now.time && issuedBook.returnStatus != 'RETURNED'}">
                                        <span class="status-badge overdue">OVERDUE</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="status-badge not-returned">NOT RETURNED</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                    </c:forEach>
                    
                 
                </tbody>
            </table>
        </div>
    </div>
    
<script>
document.addEventListener('DOMContentLoaded', function() {
    const searchInput = document.querySelector('.search-input');
    const activityTable = document.querySelector('.history-table');
    const tableRows = activityTable.querySelectorAll('tbody tr');
    
    searchInput.addEventListener('input', function() {
        const searchTerm = this.value.trim().toLowerCase();
        
        tableRows.forEach(function(row) {
            const bookTitle = row.cells[0].textContent.toLowerCase();
            const memberName = row.cells[1].textContent.toLowerCase();
            
            if (bookTitle.includes(searchTerm) || memberName.includes(searchTerm)) {
                row.style.display = '';
            } else {
                row.style.display = 'none';
            }
        });
    });
});
</script>
</body>
</html>