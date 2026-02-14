<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Issue Book - Library Management System</title>
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
        
        .form-group {
            margin-bottom: 20px;
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
        
        .form-actions {
            display: flex;
            justify-content: flex-end;
            gap: 10px;
            margin-top: 30px;
        }
        
        .book-details, .member-details {
            margin-top: 20px;
            padding: 15px;
            border: 1px solid #ddd;
            border-radius: 4px;
            background-color: #f9f9f9;
        }
        
        .detail-row {
            display: flex;
            margin-bottom: 10px;
        }
        
        .detail-label {
            font-weight: bold;
            width: 120px;
            color: #555;
        }
        
        .detail-value {
            flex: 1;
        }
        
        .detail-section-title {
            color: var(--brownie);
            font-size: 16px;
            margin-bottom: 15px;
            border-bottom: 1px solid #ddd;
            padding-bottom: 5px;
        }
        
        .form-row {
            display: flex;
            gap: 15px;
        }
        
        .form-row .form-group {
            flex: 1;
        }
        
        .hidden {
            display: none;
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
            
            .form-row {
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
            <h1 class="page-title">Issue Book</h1>
        </div>
        
        <div class="content-section">
            <c:if test="${not empty errorMessage}">
                <div class="alert alert-danger">
                    ${errorMessage}
                </div>
            </c:if>
            
            <form action="${pageContext.request.contextPath}/admin/issued-books" method="post" id="issue-form">
                <div class="form-row">
                    <div class="form-group">
                        <label for="bookId">Book</label>
                        <select class="form-control" id="bookId" name="bookId" onchange="getBookDetails()" required>
                            <option value="">Select Book</option>
                            <c:forEach var="book" items="${books}">
                                <option value="${book.id}">${book.title} (${book.availableCopies} available)</option>
                            </c:forEach>
                        </select>
                    </div>
                    
                    <div class="form-group">
                        <label for="memberId">Member</label>
                        <select class="form-control" id="memberId" name="memberId" onchange="getMemberDetails()" required>
                            <option value="">Select Member</option>
                            <c:forEach var="member" items="${members}">
                                <option value="${member.id}">${member.name} (${member.username})</option>
                            </c:forEach>
                        </select>
                    </div>
                </div>
                
                <div class="form-group">
                    <label for="dueDate">Due Date</label>
                    <input type="date" class="form-control" id="dueDate" name="dueDate" value="${defaultDueDate}" required>
                </div>
                
                <div id="book-details" class="book-details hidden">
                    <h3 class="detail-section-title">Book Details</h3>
                    
                    <div class="detail-row">
                        <div class="detail-label">Title:</div>
                        <div class="detail-value" id="book-title"></div>
                    </div>
                    
                    <div class="detail-row">
                        <div class="detail-label">Author:</div>
                        <div class="detail-value" id="book-author"></div>
                    </div>
                    
                    <div class="detail-row">
                        <div class="detail-label">ISBN:</div>
                        <div class="detail-value" id="book-isbn"></div>
                    </div>
                    
                    <div class="detail-row">
                        <div class="detail-label">Publisher:</div>
                        <div class="detail-value" id="book-publisher"></div>
                    </div>
                    
                    <div class="detail-row">
                        <div class="detail-label">Available:</div>
                        <div class="detail-value" id="book-available"></div>
                    </div>
                </div>
                
                <div id="member-details" class="member-details hidden">
                    <h3 class="detail-section-title">Member Details</h3>
                    
                    <div class="detail-row">
                        <div class="detail-label">Name:</div>
                        <div class="detail-value" id="member-name"></div>
                    </div>
                    
                    <div class="detail-row">
                        <div class="detail-label">Username:</div>
                        <div class="detail-value" id="member-username"></div>
                    </div>
                    
                    <div class="detail-row">
                        <div class="detail-label">Phone:</div>
                        <div class="detail-value" id="member-phone"></div>
                    </div>
                    
                    <div class="detail-row">
                        <div class="detail-label">Status:</div>
                        <div class="detail-value" id="member-status"></div>
                    </div>
                    
                    <div class="detail-row">
                        <div class="detail-label">Current Books:</div>
                        <div class="detail-value" id="member-books"></div>
                    </div>
                </div>
                
                <div class="form-actions">
                    <a href="${pageContext.request.contextPath}/admin/issued-books" class="btn btn-secondary">Cancel</a>
                    <button type="submit" class="btn btn-primary">Issue Book</button>
                </div>
            </form>
        </div>
    </div>
    
    <script>
        const bookSelect = document.getElementById('bookId');
        const memberSelect = document.getElementById('memberId');
        const dueDateInput = document.getElementById('dueDate');
        const bookDetailsDiv = document.getElementById('book-details');
        const memberDetailsDiv = document.getElementById('member-details');
        
        document.addEventListener('DOMContentLoaded', function() {
            const today = new Date().toISOString().split('T')[0];
            dueDateInput.setAttribute('min', today);
        });
        
        function getBookDetails() {
            const bookId = bookSelect.value;
            
            if (!bookId) {
                bookDetailsDiv.classList.add('hidden');
                return;
            }
            
            fetch('${pageContext.request.contextPath}/admin/books?action=getDetails&id=' + bookId)
                .then(response => response.json())
                .then(data => {
                    document.getElementById('book-title').textContent = data.title;
                    document.getElementById('book-author').textContent = data.author;
                    document.getElementById('book-isbn').textContent = data.isbn;
                    document.getElementById('book-publisher').textContent = data.publisher || 'N/A';
                    document.getElementById('book-available').textContent = data.availableCopies + '/' + data.totalCopies;
                    
                    bookDetailsDiv.classList.remove('hidden');
                })
                .catch(error => {
                    console.error('Error fetching book details:', error);
                    const selectedOption = bookSelect.options[bookSelect.selectedIndex];
                    document.getElementById('book-title').textContent = selectedOption.text.split(' (')[0];
                    document.getElementById('book-author').textContent = 'N/A';
                    document.getElementById('book-isbn').textContent = 'N/A';
                    document.getElementById('book-publisher').textContent = 'N/A';
                    document.getElementById('book-available').textContent = selectedOption.text.split('(')[1].replace(')', '');
                    
                    bookDetailsDiv.classList.remove('hidden');
                });
        }
        
function getMemberDetails() {
    const memberId = memberSelect.value;
    
    if (!memberId) {
        memberDetailsDiv.classList.add('hidden');
        return;
    }
    
    fetch('${pageContext.request.contextPath}/admin/members?action=getDetails&id=' + memberId)
        .then(response => {
            if (!response.ok) {
                throw new Error('Failed to fetch member details');
            }
            return response.json();
        })
        .then(data => {
            // Populate member details
            document.getElementById('member-name').textContent = data.name;
            document.getElementById('member-username').textContent = data.username;
            document.getElementById('member-phone').textContent = data.phoneNumber || 'N/A';
            document.getElementById('member-status').textContent = data.status || 'N/A';
            document.getElementById('member-books').textContent = data.currentBooks || '0';
            
            // Show member details
            memberDetailsDiv.classList.remove('hidden');
        })
        .catch(error => {
            console.error('Error fetching member details:', error);
            // Use option text as fallback
            const selectedOption = memberSelect.options[memberSelect.selectedIndex];
            document.getElementById('member-name').textContent = selectedOption.text.split(' (')[0];
            document.getElementById('member-username').textContent = selectedOption.text.split('(')[1].replace(')', '');
            document.getElementById('member-phone').textContent = 'N/A';
            document.getElementById('member-status').textContent = 'N/A';
            document.getElementById('member-books').textContent = 'N/A';
            
            memberDetailsDiv.classList.remove('hidden');
        });
}
    </script>
</body>
</html>