<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Issued Books - Library Management System</title>
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
        
        .btn-secondary {
            background-color: #6c757d;
            color: white;
        }
        
        .btn-secondary:hover {
            background-color: #5a6268;
        }
        
        .btn-warning {
            background-color: #ffc107;
            color: #212529;
        }
        
        .btn-warning:hover {
            background-color: #e0a800;
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
        
        .returned {
            background-color: #2ecc71;
            color: white;
        }
        
        .not-returned {
            background-color: #e74c3c;
            color: white;
        }
        
        .on-time {
            background-color: #3498db;
            color: white;
        }
        
        .overdue {
            background-color: #e74c3c;
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
        
        .none {
            background-color: #95a5a6;
            color: white;
        }
        
        .extension-modal {
            display: none;
            position: fixed;
            z-index: 1000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.5);
            overflow: auto;
        }
        
        .modal-content {
            background-color: white;
            margin: 10% auto;
            padding: 30px;
            border-radius: 8px;
            max-width: 500px;
            position: relative;
            animation: modalopen 0.4s;
        }
        
        @keyframes modalopen {
            from {opacity: 0; transform: translateY(-30px);}
            to {opacity: 1; transform: translateY(0);}
        }
        
        .close-btn {
            position: absolute;
            top: 10px;
            right: 20px;
            color: #888;
            font-size: 24px;
            font-weight: bold;
            cursor: pointer;
        }
        
        .close-btn:hover {
            color: #333;
        }
        
        .modal-title {
            color: var(--brownie);
            margin-bottom: 20px;
            font-size: 20px;
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
        
        .form-actions {
            display: flex;
            justify-content: flex-end;
            gap: 10px;
            margin-top: 20px;
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
            <h1 class="page-title">Issued Books</h1>
            <a href="${pageContext.request.contextPath}/admin/issued-books?action=issue" class="btn btn-primary">Issue New Book</a>
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
            <div class="actions-header">
                <div class="filter-links">
                    <a href="${pageContext.request.contextPath}/admin/issued-books" class="filter-link ${empty param.filter && empty param.action ? 'active' : ''}">All</a>
                    <a href="${pageContext.request.contextPath}/admin/issued-books?filter=not-returned" class="filter-link ${param.filter == 'not-returned' ? 'active' : ''}">Not Returned</a>
                    <a href="${pageContext.request.contextPath}/admin/issued-books?filter=returned" class="filter-link ${param.filter == 'returned' ? 'active' : ''}">Returned</a>
                    <a href="${pageContext.request.contextPath}/admin/issued-books?action=overdue" class="filter-link ${param.action == 'overdue' ? 'active' : ''}">Overdue</a>
                    <a href="${pageContext.request.contextPath}/admin/issued-books?filter=extension-requests" class="filter-link ${param.filter == 'extension-requests' ? 'active' : ''}">Extension Requests</a>
                </div>
            </div>
            
            <table class="issued-books-table">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Book</th>
                        <th>Member</th>
                        <th>Issue Date</th>
                        <th>Due Date</th>
                        <th>Return Date</th>
                        <th>Status</th>
                        <th>Extension</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="issuedBook" items="${issuedBooks}">
                        <tr>
                            <td>${issuedBook.id}</td>
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
                                    <c:when test="${issuedBook.returnStatus == 'NOT_RETURNED' && issuedBook.dueDate.time lt now.time}">
                                        <span class="status-badge overdue">OVERDUE</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="status-badge not-returned">NOT RETURNED</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${issuedBook.extensionStatus == 'REQUESTED'}">
                                        <span class="status-badge requested">REQUESTED</span>
                                    </c:when>
                                    <c:when test="${issuedBook.extensionStatus == 'APPROVED'}">
                                        <span class="status-badge approved">APPROVED</span>
                                    </c:when>
                                    <c:when test="${issuedBook.extensionStatus == 'REJECTED'}">
                                        <span class="status-badge rejected">REJECTED</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="status-badge none">NONE</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <c:if test="${issuedBook.returnStatus == 'NOT_RETURNED'}">
                                    <a href="${pageContext.request.contextPath}/admin/return-books?action=search&bookId=${issuedBook.bookId}" class="btn btn-primary btn-sm">Return</a>
                                </c:if>
                                <c:if test="${issuedBook.extensionStatus == 'REQUESTED' && issuedBook.returnStatus != 'RETURNED'}">
                                    <button class="btn btn-warning btn-sm" onclick="openExtensionModal(${issuedBook.id})">Process Extension</button>
                                </c:if>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
    
    <!-- Extension Request Modal (Hidden by default) -->
    <div id="extension-modal" class="extension-modal">
        <div class="modal-content">
            <span class="close-btn" onclick="closeExtensionModal()">&times;</span>
            <h2 class="modal-title">Process Extension Request</h2>
            
            <form action="${pageContext.request.contextPath}/admin/issued-books" method="get">
                <input type="hidden" name="action" value="extension">
                <input type="hidden" id="issued-book-id" name="id">
                
                <div class="form-group">
                    <label for="extension-action">Action</label>
                    <select class="form-control" id="extension-action" name="extensionAction" onchange="toggleDueDateField()">
                        <option value="approve">Approve</option>
                        <option value="reject">Reject</option>
                    </select>
                </div>
                
                <div class="form-group" id="due-date-group">
                    <label for="new-due-date">New Due Date</label>
                    <input type="date" class="form-control" id="new-due-date" name="newDueDate">
                </div>
                
                <div class="form-actions">
                    <button type="button" class="btn btn-secondary" onclick="closeExtensionModal()">Cancel</button>
                    <button type="submit" class="btn btn-primary">Submit</button>
                </div>
            </form>
        </div>
    </div>
    
    <script>
        // DOM Elements
        const extensionModal = document.getElementById('extension-modal');
        const issuedBookIdInput = document.getElementById('issued-book-id');
        const extensionActionSelect = document.getElementById('extension-action');
        const dueDateGroup = document.getElementById('due-date-group');
        const newDueDateInput = document.getElementById('new-due-date');
        
        // Set default due date (14 days from now)
        function setDefaultDueDate() {
            const now = new Date();
            now.setDate(now.getDate() + 14);
            const year = now.getFullYear();
            const month = String(now.getMonth() + 1).padStart(2, '0');
            const day = String(now.getDate()).padStart(2, '0');
            newDueDateInput.value = `${year}-${month}-${day}`;
        }
        
        // Toggle due date field based on action
        function toggleDueDateField() {
            if (extensionActionSelect.value === 'approve') {
                dueDateGroup.style.display = 'block';
                setDefaultDueDate();
            } else {
                dueDateGroup.style.display = 'none';
            }
        }
        
        // Open extension modal
        function openExtensionModal(issuedBookId) {
            issuedBookIdInput.value = issuedBookId;
            setDefaultDueDate();
            toggleDueDateField();
            extensionModal.style.display = 'block';
        }
        
        // Close extension modal
        function closeExtensionModal() {
            extensionModal.style.display = 'none';
        }
        
        // Close modal when clicking outside
        window.onclick = function(event) {
            if (event.target === extensionModal) {
                closeExtensionModal();
            }
        };
        
        // Initialize
        document.addEventListener('DOMContentLoaded', function() {
            // Set today's date as min for new due date
            const today = new Date().toISOString().split('T')[0];
            newDueDateInput.setAttribute('min', today);
        });
        
        // Open extension modal
function openExtensionModal(issuedBookId, returnStatus) {
    // Check if book is already returned
    if (returnStatus === 'RETURNED') {
        alert('Cannot process extension for already returned books');
        return;
    }
    
    issuedBookIdInput.value = issuedBookId;
    setDefaultDueDate();
    toggleDueDateField();
    extensionModal.style.display = 'block';
}
    </script>
</body>
</html>