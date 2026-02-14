<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Members - Library Management System</title>
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
        
        .btn-sm {
            padding: 5px 10px;
            font-size: 14px;
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
        
        .members-table {
            width: 100%;
            border-collapse: collapse;
        }
        
        .members-table th {
            text-align: left;
            padding: 12px 15px;
            background-color: var(--cream);
            color: var(--brownie);
        }
        
        .members-table td {
            padding: 12px 15px;
            border-bottom: 1px solid #f0f0f0;
        }
        
        .members-table tr:last-child td {
            border-bottom: none;
        }
        
        .members-table tr:nth-child(even) {
            background-color: #fdfdfd;
        }
        
        .status-badge {
            display: inline-block;
            padding: 3px 8px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: bold;
        }
        
        .active {
            background-color: #2ecc71;
            color: white;
        }
        
        .inactive {
            background-color: #e74c3c;
            color: white;
        }
        
        .actions {
            display: flex;
            gap: 5px;
        }
        
        .action-btn {
            padding: 6px 12px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 14px;
            transition: background-color 0.3s;
            text-decoration: none;
            display: inline-block;
        }
        
        .edit-btn {
            background-color: #3498db;
            color: white;
        }
        
        .edit-btn:hover {
            background-color: #2980b9;
        }
        
        .delete-btn {
            background-color: #e74c3c;
            color: white;
        }
        
        .delete-btn:hover {
            background-color: #c0392b;
        }
        
        .highlighted {
            animation: highlight 3s ease-out;
        }
        
        @keyframes highlight {
            0% { background-color: #ffffcc; }
            100% { background-color: transparent; }
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
        }
        
        /* Delete Modal */
        .modal {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0,0,0,0.5);
            z-index: 1000;
            align-items: center;
            justify-content: center;
        }
        
        .modal-content {
            background-color: white;
            padding: 20px;
            border-radius: 8px;
            max-width: 500px;
            width: 100%;
            box-shadow: 0 4px 8px rgba(0,0,0,0.2);
        }
        
        .modal-title {
            color: var(--brownie);
            margin-bottom: 15px;
            font-size: 20px;
        }
        
        .modal-actions {
            display: flex;
            justify-content: flex-end;
            gap: 10px;
            margin-top: 20px;
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
            <li><a href="${pageContext.request.contextPath}/admin/members" class="active">Members</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/issued-books">Issued Books</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/return-books">Return Books</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/history">History</a></li>
            <li><a href="${pageContext.request.contextPath}/logout">Logout</a></li>
        </ul>
    </div>
    
    <div class="main-content">
        <div class="header">
            <h1 class="page-title">Manage Members</h1>
            <a href="${pageContext.request.contextPath}/admin/members?action=add" class="btn btn-primary">Add New Member</a>
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
        
        <form action="${pageContext.request.contextPath}/admin/members" method="post" class="search-bar">
            <input type="hidden" name="action" value="search">
            <input type="text" class="search-input" name="searchTerm" placeholder="Search by name, username, or phone number..." value="${searchTerm}">
        </form>
        
        <div class="content-section">
            <table class="members-table">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Name</th>
                        <th>Username</th>
                        <th>Phone Number</th>
                        <th>Register Date</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="member" items="${members}">
                        <tr data-id="${member.id}" ${member.id == newMemberId ? 'class="highlighted"' : ''}>
                            <td>${member.id}</td>
                            <td>${member.name}</td>
                            <td>${member.username}</td>
                            <td>${member.phoneNumber}</td>
                            <td><fmt:formatDate value="${member.registerDate}" pattern="yyyy-MM-dd" /></td>
                            <td>
                                <span class="status-badge ${member.status == 'ACTIVE' ? 'active' : 'inactive'}">
                                    ${member.status}
                                </span>
                            </td>
                            <td class="actions">
                                <a href="${pageContext.request.contextPath}/admin/members?action=edit&id=${member.id}" class="action-btn edit-btn">Edit</a>
                                <a href="#" onclick="confirmDelete(${member.id}, '${member.name}')" class="action-btn delete-btn">Delete</a>
                            </td>
                        </tr>
                    </c:forEach>
                    
                    <c:if test="${empty members}">
                        <tr>
                            <td colspan="7" style="text-align: center; padding: 20px;">No members found.</td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </div>
    
    <!-- Delete Confirmation Modal -->
    <div id="deleteModal" class="modal">
        <div class="modal-content">
            <h3 class="modal-title">Confirm Delete</h3>
            <p id="deleteMessage">Are you sure you want to delete this member?</p>
            <div class="modal-actions">
                <button class="btn btn-secondary" onclick="hideDeleteModal()">Cancel</button>
                <a href="#" id="confirmDeleteBtn" class="btn btn-primary" style="background-color: #e74c3c;">Delete</a>
            </div>
        </div>
    </div>
    
    <script>
        // DOM Elements
        const searchInput = document.querySelector('.search-input');
        const deleteModal = document.getElementById('deleteModal');
        const deleteMessage = document.getElementById('deleteMessage');
        const confirmDeleteBtn = document.getElementById('confirmDeleteBtn');
        
        // Submit search form when pressing Enter
        searchInput.addEventListener('keypress', function(e) {
            if (e.key === 'Enter') {
                this.closest('form').submit();
            }
        });
        
        // Confirm delete
        function confirmDelete(id, name) {
            deleteMessage.textContent = `Are you sure you want to delete the member "${name}"?`;
            confirmDeleteBtn.href = "${pageContext.request.contextPath}/admin/members?action=delete&id=" + id;
            deleteModal.style.display = 'flex';
        }
        
        // Hide delete modal
        function hideDeleteModal() {
            deleteModal.style.display = 'none';
        }
        
        // Close modal when clicking outside
        window.onclick = function(event) {
            if (event.target === deleteModal) {
                hideDeleteModal();
            }
        };
        
        // Highlight newly added or updated member
        document.addEventListener('DOMContentLoaded', function() {
            const highlightedRow = document.querySelector('tr.highlighted');
            if (highlightedRow) {
                highlightedRow.scrollIntoView({ behavior: 'smooth', block: 'center' });
            }
        });
    </script>
</body>
</html>