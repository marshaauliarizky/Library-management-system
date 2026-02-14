<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Return Books - Library Management System</title>
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
        
        .content-section {
            background-color: white;
            border-radius: 8px;
            padding: 30px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.05);
            max-width: 800px;
            margin: 0 auto;
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
        
        .search-section {
            margin-bottom: 30px;
            padding: 20px;
            background-color: #f8f9fa;
            border-radius: 8px;
        }
        
        .search-form {
            display: flex;
            flex-wrap: wrap;
            gap: 15px;
        }
        
        .form-group {
            flex: 1;
            min-width: 200px;
        }
        
        .form-group label {
            display: block;
            margin-bottom: 8px;
            color: #333;
            font-weight: bold;
        }
        
        .form-control {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 16px;
        }
        
        .btn {
            padding: 12px 20px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 16px;
            font-weight: bold;
            transition: background-color 0.3s;
            display: inline-block;
            text-decoration: none;
            text-align: center;
        }
        
        .btn-primary {
            background-color: var(--caramel);
            color: white;
        }
        
        .btn-primary:hover {
            background-color: #a6723f;
        }
        
        .btn-secondary {
            background-color: #6c757d;
            color: white;
        }
        
        .btn-secondary:hover {
            background-color: #5a6268;
        }
        
        .search-button {
            align-self: flex-end;
            margin-bottom: 1px;
        }
        
        .issued-books-table {
            width: 100%;
            border-collapse: collapse;
        }
        
        .issued-books-table th {
            text-align: left;
            padding: 12px 15px;
            background-color: var(--cream);
            color: var(--brownie);
        }
        
        .issued-books-table td {
            padding: 12px 15px;
            border-bottom: 1px solid #f0f0f0;
        }
        
        .issued-books-table tr:last-child td {
            border-bottom: none;
        }
        
        .issued-books-table tr:nth-child(even) {
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
            background-color: #28a745;
            color: white;
        }
        
        .overdue {
            background-color: #dc3545;
            color: white;
        }
        
        .action-button {
            text-align: center;
        }
        
        .btn-sm {
            padding: 5px 10px;
            font-size: 14px;
        }
        
        .return-confirmation {
            display: none;
            background-color: #f8f9fa;
            border: 1px solid #ddd;
            border-radius: 8px;
            padding: 20px;
            margin-top: 20px;
        }
        
        .return-details {
            margin-bottom: 20px;
        }
        
        .return-details h3 {
            color: var(--brownie);
            margin-bottom: 15px;
            font-size: 18px;
        }
        
        .detail-row {
            display: flex;
            margin-bottom: 10px;
        }
        
        .detail-label {
            font-weight: bold;
            width: 150px;
            color: #555;
        }
        
        .return-actions {
            display: flex;
            justify-content: flex-end;
            gap: 10px;
        }
        
        .no-results {
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
            
            .search-form {
                flex-direction: column;
            }
            
            .search-button {
                align-self: stretch;
                margin-top: 10px;
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
            <li><a href="${pageContext.request.contextPath}/admin/issued-books">Issued Books</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/return-books" class="active">Return Books</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/history">History</a></li>
            <li><a href="${pageContext.request.contextPath}/logout">Logout</a></li>
        </ul>
    </div>
    
    <div class="main-content">
        <div class="header">
            <h1 class="page-title">Return Books</h1>
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
        
        <div class="content-section">
            <div class="search-section">
                <h2>Search for Books to Return</h2>
                <form action="${pageContext.request.contextPath}/admin/return-books" method="get" class="search-form">
                    <input type="hidden" name="action" value="search">
                    
                    <div class="form-group">
                        <label for="bookTitle">Book Title</label>
                        <input type="text" class="form-control" id="bookTitle" name="bookTitle" placeholder="Enter Book Title" value="${param.bookTitle}">
                    </div>

                    <div class="form-group">
                        <label for="memberName">Member Name</label>
                        <input type="text" class="form-control" id="memberName" name="memberName" placeholder="Enter Member Name" value="${param.memberName}">
                    </div>

                    <div class="search-button">
                        <button type="submit" class="btn btn-primary">Search</button>
                    </div>
                </form>
            </div>
            
            <c:if test="${searchPerformed}">
                <c:choose>
                    <c:when test="${empty notReturnedBooks}">
                        <div class="no-results">
                            <p>No books found matching your search criteria.</p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <table class="issued-books-table">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Book Title</th>
                                    <th>Member Name</th>
                                    <th>Issue Date</th>
                                    <th>Due Date</th>
                                    <th>Status</th>
                                    <th>Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="issuedBook" items="${notReturnedBooks}">
                                    <tr>
                                        <td>${issuedBook.id}</td>
                                        <td>${issuedBook.bookTitle}</td>
                                        <td>${issuedBook.memberName}</td>
                                        <td><fmt:formatDate value="${issuedBook.dateIssued}" pattern="yyyy-MM-dd" /></td>
                                        <td><fmt:formatDate value="${issuedBook.dueDate}" pattern="yyyy-MM-dd" /></td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${issuedBook.dueDate.time lt now.time}">
                                                    <span class="status-badge overdue">OVERDUE</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="status-badge on-time">ON TIME</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="action-button">
                                            <button class="btn btn-primary btn-sm" onclick="showReturnConfirmation(${issuedBook.id}, '${issuedBook.bookTitle}', '${issuedBook.memberName}', '<fmt:formatDate value="${issuedBook.dateIssued}" pattern="yyyy-MM-dd" />', '<fmt:formatDate value="${issuedBook.dueDate}" pattern="yyyy-MM-dd" />')">Return</button>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </c:otherwise>
                </c:choose>
            </c:if>
            
            <c:if test="${not searchPerformed and not empty notReturnedBooks}">
                <table class="issued-books-table">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Book Title</th>
                            <th>Member Name</th>
                            <th>Issue Date</th>
                            <th>Due Date</th>
                            <th>Status</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="issuedBook" items="${notReturnedBooks}">
                            <tr>
                                <td>${issuedBook.id}</td>
                                <td>${issuedBook.bookTitle}</td>
                                <td>${issuedBook.memberName}</td>
                                <td><fmt:formatDate value="${issuedBook.dateIssued}" pattern="yyyy-MM-dd" /></td>
                                <td><fmt:formatDate value="${issuedBook.dueDate}" pattern="yyyy-MM-dd" /></td>
                                <td>
                                    <c:choose>
                                        <c:when test="${issuedBook.dueDate.time lt now.time}">
                                            <span class="status-badge overdue">OVERDUE</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="status-badge on-time">ON TIME</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="action-button">
                                    <button class="btn btn-primary btn-sm" onclick="showReturnConfirmation(${issuedBook.id}, '${issuedBook.bookTitle}', '${issuedBook.memberName}', '<fmt:formatDate value="${issuedBook.dateIssued}" pattern="yyyy-MM-dd" />', '<fmt:formatDate value="${issuedBook.dueDate}" pattern="yyyy-MM-dd" />')">Return</button>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </c:if>
            
            <div id="return-confirmation" class="return-confirmation">
                <div class="return-details">
                    <h3>Return Book Confirmation</h3>
                    
                    <div class="detail-row">
                        <div class="detail-label">Issued Book ID:</div>
                        <div class="detail-value" id="confirm-id"></div>
                    </div>
                    
                    <div class="detail-row">
                        <div class="detail-label">Book Title:</div>
                        <div class="detail-value" id="confirm-title"></div>
                    </div>
                    
                    <div class="detail-row">
                        <div class="detail-label">Member Name:</div>
                        <div class="detail-value" id="confirm-member"></div>
                    </div>
                    
                    <div class="detail-row">
                        <div class="detail-label">Issue Date:</div>
                        <div class="detail-value" id="confirm-issue-date"></div>
                    </div>
                    
                    <div class="detail-row">
                        <div class="detail-label">Due Date:</div>
                        <div class="detail-value" id="confirm-due-date"></div>
                    </div>
                    
                    <div class="detail-row">
                        <div class="detail-label">Return Date:</div>
                        <div class="detail-value">
                            <script>
                                document.write(new Date().toISOString().split('T')[0]);
                            </script>
                        </div>
                    </div>
                </div>
                
                <form action="${pageContext.request.contextPath}/admin/return-books" method="post">
                    <input type="hidden" name="action" value="return">
                    <input type="hidden" id="issued-book-id" name="issuedBookId">
                    
                    <div class="return-actions">
                        <button type="button" class="btn btn-secondary" onclick="hideReturnConfirmation()">Cancel</button>
                        <button type="submit" class="btn btn-primary">Confirm Return</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    
    <script>
        // Show return confirmation
        function showReturnConfirmation(id, title, member, issueDate, dueDate) {
            document.getElementById('confirm-id').textContent = id;
            document.getElementById('confirm-title').textContent = title;
            document.getElementById('confirm-member').textContent = member;
            document.getElementById('confirm-issue-date').textContent = issueDate;
            document.getElementById('confirm-due-date').textContent = dueDate;
            document.getElementById('issued-book-id').value = id;
            
            document.getElementById('return-confirmation').style.display = 'block';
            
            // Scroll to confirmation
            document.getElementById('return-confirmation').scrollIntoView({ behavior: 'smooth' });
        }
        
        // Hide return confirmation
        function hideReturnConfirmation() {
            document.getElementById('return-confirmation').style.display = 'none';
        }
        
        // Form validation
        document.querySelectorAll('form').forEach(function(form) {
            form.addEventListener('submit', function(event) {
                const bookId = document.getElementById('bookId');
                const memberId = document.getElementById('memberId');
                
                if (form.getAttribute('action').includes('action=search') && 
                    (bookId.value.trim() === '' && memberId.value.trim() === '')) {
                    event.preventDefault();
                    alert('Please enter either Book ID or Member ID for search.');
                }
            });
        });
    </script>
</body>
</html>