<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Borrowed Books - Library Management System</title>
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
        
        .tab-container {
            margin-bottom: 30px;
        }
        
        .tabs {
            display: flex;
            border-bottom: 2px solid #ddd;
        }
        
        .tab {
            padding: 10px 20px;
            cursor: pointer;
            margin-right: 5px;
            border: 1px solid #ddd;
            border-bottom: none;
            border-radius: 5px 5px 0 0;
            background-color: #f8f9fa;
            color: #555;
        }
        
        .tab.active {
            background-color: var(--caramel);
            color: white;
            border-color: var(--caramel);
        }
        
        .tab-content {
            display: none;
        }
        
        .tab-content.active {
            display: block;
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
        
        .content-section {
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
            padding: 12px 15px;
            background-color: var(--cream);
            color: var(--brownie);
        }
        
        .books-table td {
            padding: 12px 15px;
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
        
        .returned {
            background-color: #3498db;
            color: white;
        }
        
        .requested {
            background-color: #f39c12;
            color: white;
        }
        
        .approved {
            background-color: #2ecc71;
            color: white;
        }
        
        .rejected {
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
            transition: background-color 0.3s;
            text-decoration: none;
            display: inline-block;
        }
        
        .btn-primary {
            background-color: var(--caramel);
            color: white;
        }
        
        .btn-primary:hover {
            background-color: #a6723f;
        }
        
        .btn-danger {
            background-color: #dc3545;
            color: white;
        }
        
        .btn-danger:hover {
            background-color: #c82333;
        }
        
        .btn-disabled {
            background-color: #ccc;
            color: #666;
            cursor: not-allowed;
        }
        
        .empty-message {
            text-align: center;
            padding: 30px;
            color: #666;
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
            
            .tabs {
                flex-direction: column;
                border-bottom: none;
            }
            
            .tab {
                margin-right: 0;
                margin-bottom: 5px;
                border-radius: 5px;
                border: 1px solid #ddd;
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
            <li><a href="${pageContext.request.contextPath}/member/issued-books" class="active">My Borrowed Books</a></li>
            <li><a href="${pageContext.request.contextPath}/member/history">My History</a></li>
            <li><a href="${pageContext.request.contextPath}/member/profile">My Profile</a></li>
            <li><a href="${pageContext.request.contextPath}/logout">Logout</a></li>
        </ul>
    </div>
    
    <div class="main-content">
        <div class="header">
            <h1 class="page-title">My Borrowed Books</h1>
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
        
        <div class="tab-container">
            <div class="tabs">
                <div class="tab active" onclick="openTab('current')">Currently Borrowed</div>
                <div class="tab" onclick="openTab('returned')">Returned Books</div>
            </div>
            
            <div id="current" class="tab-content active">
                <div class="content-section">
                    <c:choose>
                        <c:when test="${empty currentlyBorrowedBooks}">
                            <div class="empty-message">
                                You don't have any borrowed books at the moment.
                            </div>
                        </c:when>
                        <c:otherwise>
                            <table class="books-table">
                                <thead>
                                    <tr>
                                        <th>Book Title</th>
                                        <th>Issue Date</th>
                                        <th>Due Date</th>
                                        <th>Status</th>
                                        <th>Extension</th>
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
                                                <c:choose>
                                                    <c:when test="${book.extensionStatus == 'REQUESTED'}">
                                                        <span class="status-badge requested">REQUESTED</span>
                                                    </c:when>
                                                    <c:when test="${book.extensionStatus == 'APPROVED'}">
                                                        <span class="status-badge approved">APPROVED</span>
                                                    </c:when>
                                                    <c:when test="${book.extensionStatus == 'REJECTED'}">
                                                        <span class="status-badge rejected">REJECTED</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span>-</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <div style="display: flex; gap: 10px;">
    <c:if test="${issuedBook.returnStatus == 'NOT_RETURNED'}">
        <a href="${pageContext.request.contextPath}/admin/return-books?action=search&bookId=${issuedBook.bookId}" class="btn btn-primary btn-sm">Return</a>
    </c:if>
    <c:if test="${issuedBook.extensionStatus == 'REQUESTED' && issuedBook.returnStatus != 'RETURNED'}">
        <button class="btn btn-warning btn-sm" onclick="openExtensionModal(${issuedBook.id})">Process Extension</button>
    </c:if>
               <c:if test="${book.returnStatus == 'NOT_RETURNED'}">
                    <form action="${pageContext.request.contextPath}/member/return-book" method="post" 
                          onsubmit="return confirm('Apakah Anda yakin ingin mengembalikan buku ini?')">
                        <input type="hidden" name="issuedBookId" value="${book.id}">
                        <button type="submit" class="btn btn-danger">Return</button>
                    </form>
                </c:if>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
            
            <div id="returned" class="tab-content">
                <div class="content-section">
                    <c:choose>
                        <c:when test="${empty returnedBooks}">
                            <div class="empty-message">
                                You haven't returned any books yet.
                            </div>
                        </c:when>
                        <c:otherwise>
                            <table class="books-table">
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
                                    <c:forEach var="book" items="${returnedBooks}">
                                        <tr>
                                            <td>${book.bookTitle}</td>
                                            <td><fmt:formatDate value="${book.dateIssued}" pattern="yyyy-MM-dd" /></td>
                                            <td><fmt:formatDate value="${book.dueDate}" pattern="yyyy-MM-dd" /></td>
                                            <td><fmt:formatDate value="${book.dateReturned}" pattern="yyyy-MM-dd" /></td>
                                            <td>
                                                <span class="status-badge returned">RETURNED</span>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </div>
    
    <script>
        function openTab(tabName) {
            // Hide all tab contents
            var tabContents = document.getElementsByClassName('tab-content');
            for (var i = 0; i < tabContents.length; i++) {
                tabContents[i].classList.remove('active');
            }
            
            // Remove active class from all tabs
            var tabs = document.getElementsByClassName('tab');
            for (var i = 0; i < tabs.length; i++) {
                tabs[i].classList.remove('active');
            }
            
            // Show the selected tab content
            document.getElementById(tabName).classList.add('active');
            
            // Add active class to the clicked tab
            var tabIndex = (tabName === 'current') ? 0 : 1;
            tabs[tabIndex].classList.add('active');
        }
    </script>
</body>
</html>