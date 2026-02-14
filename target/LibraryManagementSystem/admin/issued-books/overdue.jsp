<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Overdue Books - Library Management System</title>
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
            z-index: 1;
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
        
        .btn {
            padding: 10px 20px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 16px;
            font-weight: bold;
            text-decoration: none;
            transition: background-color 0.3s;
            display: inline-block;
        }
        
        .btn-primary {
            background-color: var(--caramel);
            color: white;
        }
        
        .btn-primary:hover {
            background-color: #a6723f;
        }
        
        .btn-sm {
            padding: 5px 10px;
            font-size: 14px;
        }
        
        .alert {
            padding: 15px;
            border-radius: 4px;
            margin-bottom: 20px;
        }
        
        .alert-danger {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
        
        .content-section {
            background-color: white;
            border-radius: 8px;
            padding: 20px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.05);
        }
        
        .actions-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }
        
        .filter-links {
            display: flex;
            gap: 15px;
            flex-wrap: wrap;
        }
        
        .filter-link {
            color: var(--brownie);
            text-decoration: none;
            font-weight: bold;
            padding: 5px;
            border-bottom: 2px solid transparent;
            transition: border-color 0.3s;
        }
        
        .filter-link:hover, .filter-link.active {
            border-color: var(--caramel);
        }
        
        .overdue-books-table {
            width: 100%;
            border-collapse: collapse;
        }
        
        .overdue-books-table th {
            text-align: left;
            padding: 12px 15px;
            background-color: var(--cream);
            color: var(--brownie);
        }
        
        .overdue-books-table td {
            padding: 12px 15px;
            border-bottom: 1px solid #f0f0f0;
        }
        
        .overdue-books-table tr:last-child td {
            border-bottom: none;
        }
        
        .overdue-books-table tr:nth-child(even) {
            background-color: #fdfdfd;
        }
        
        .status-badge {
            display: inline-block;
            padding: 3px 8px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: bold;
        }
        
        .overdue {
            background-color: #e74c3c;
            color: white;
        }
        
        .days-overdue {
            font-weight: bold;
            color: #e74c3c;
        }
        
        .search-section {
            margin-bottom: 20px;
        }
        
        .search-form {
            display: flex;
            gap: 10px;
            align-items: flex-end;
        }
        
        .form-group {
            flex: 1;
        }
        
        .form-group label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
        }
        
        .form-control {
            width: 100%;
            padding: 8px 12px;
            border: 1px solid #ddd;
            border-radius: 4px;
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
            
            .filter-links {
                flex-direction: column;
                gap: 5px;
            }
            
            .search-form {
                flex-direction: column;
                gap: 15px;
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
            <li><a href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/books">Books</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/members">Members</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/issued-books" class="active">Issued Books</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/return-books">Return Books</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/history">History</a></li>
            <li><a href="${pageContext.request.contextPath}/logout">Logout</a></li>
        </ul>
    </div>
    
    <div class="main-content">
        <div class="header">
            <h1 class="page-title">Overdue Books</h1>
        </div>
        
        <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger">
                ${errorMessage}
            </div>
        </c:if>
        
        <div class="content-section">
            <div class="actions-header">
                <div class="filter-links">
                    <a href="${pageContext.request.contextPath}/admin/issued-books" class="filter-link">All</a>
                    <a href="${pageContext.request.contextPath}/admin/issued-books?filter=not-returned" class="filter-link">Not Returned</a>
                    <a href="${pageContext.request.contextPath}/admin/issued-books?filter=returned" class="filter-link">Returned</a>
                    <a href="${pageContext.request.contextPath}/admin/issued-books?action=overdue" class="filter-link active">Overdue</a>
                    <a href="${pageContext.request.contextPath}/admin/issued-books?filter=extension-requests" class="filter-link">Extension Requests</a>
                </div>
            </div>
            
            <div class="search-section">
                <form action="${pageContext.request.contextPath}/admin/issued-books" method="get" class="search-form">
                    <input type="hidden" name="action" value="overdue">
                    
                    <div class="form-group">
                        <label for="member-search">Search by Member:</label>
                        <input type="text" id="member-search" name="memberSearch" class="form-control" placeholder="Member name">
                    </div>
                    
                    <div class="form-group">
                        <label for="book-search">Search by Book:</label>
                        <input type="text" id="book-search" name="bookSearch" class="form-control" placeholder="Book title">
                    </div>
                    
                    <button type="submit" class="btn btn-primary">Search</button>
                </form>
            </div>
            
            <table class="overdue-books-table">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Book</th>
                        <th>Member</th>
                        <th>Issue Date</th>
                        <th>Due Date</th>
                        <th>Days Overdue</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:if test="${empty issuedBooks}">
                        <tr>
                            <td colspan="8" style="text-align: center; padding: 20px;">
                                No overdue books found.
                            </td>
                        </tr>
                    </c:if>
                    
                    <c:forEach var="issuedBook" items="${issuedBooks}">
                        <tr>
                            <td>${issuedBook.id}</td>
                            <td>${issuedBook.bookTitle}</td>
                            <td>${issuedBook.memberName}</td>
                            <td><fmt:formatDate value="${issuedBook.dateIssued}" pattern="yyyy-MM-dd" /></td>
                            <td><fmt:formatDate value="${issuedBook.dueDate}" pattern="yyyy-MM-dd" /></td>
                            <td class="days-overdue">
                                <c:set var="dueDate" value="${issuedBook.dueDate.time}" />
                                <c:set var="today" value="${now.time}" />
                                <c:set var="diffTime" value="${today - dueDate}" />
                                <c:set var="diffDays" value="${diffTime / (24 * 60 * 60 * 1000)}" />
                                <fmt:formatNumber value="${diffDays}" pattern="#0" /> days
                            </td>
                            <td>
                                <span class="status-badge overdue">OVERDUE</span>
                            </td>
                            <td>
                                <a href="${pageContext.request.contextPath}/admin/return-books?action=search&bookId=${issuedBook.bookId}" class="btn btn-primary btn-sm">Return</a>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
    
    <script>
        // Simple filter functionality for the table
        document.addEventListener('DOMContentLoaded', function() {
            const memberSearch = document.getElementById('member-search');
            const bookSearch = document.getElementById('book-search');
            const table = document.querySelector('.overdue-books-table');
            const rows = table.querySelectorAll('tbody tr');
            
            function filterTable() {
                const memberFilter = memberSearch.value.toLowerCase();
                const bookFilter = bookSearch.value.toLowerCase();
                
                rows.forEach(row => {
                    if (row.cells.length <= 1) return; // Skip "no results" row
                    
                    const memberText = row.cells[2].textContent.toLowerCase();
                    const bookText = row.cells[1].textContent.toLowerCase();
                    
                    if ((memberFilter === '' || memberText.includes(memberFilter)) && 
                        (bookFilter === '' || bookText.includes(bookFilter))) {
                        row.style.display = '';
                    } else {
                        row.style.display = 'none';
                    }
                });
            }
            
            memberSearch.addEventListener('input', filterTable);
            bookSearch.addEventListener('input', filterTable);
        });
    </script>
</body>
</html>