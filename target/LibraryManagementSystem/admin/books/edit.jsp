<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Book - Library Management System</title>
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
            <li><a href="${pageContext.request.contextPath}/admin/books" class="active">Books</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/members">Members</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/issued-books">Issued Books</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/return-books">Return Books</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/history">History</a></li>
            <li><a href="${pageContext.request.contextPath}/logout">Logout</a></li>
        </ul>
    </div>
    
    <div class="main-content">
        <div class="header">
            <h1 class="page-title">Edit Book</h1>
        </div>
        
        <div class="content-section">
            <c:if test="${not empty errorMessage}">
                <div class="alert alert-danger">
                    ${errorMessage}
                </div>
            </c:if>
            
            <form action="${pageContext.request.contextPath}/admin/books" method="post">
                <input type="hidden" name="action" value="save">
                <input type="hidden" name="id" value="${book.id}">
                
                <div class="form-group">
                    <label for="title">Title</label>
                    <input type="text" class="form-control" id="title" name="title" value="${book.title}" required>
                </div>
                
                <div class="form-group">
                   <label for="synopsis">Synopsis</label>
                   <textarea name="synopsis" id="synopsis" rows="4" cols="50">${book != null ? book.synopsis : ""}</textarea>
                </div>
                
                <div class="form-group">
                    <label for="author">Author</label>
                    <input type="text" class="form-control" id="author" name="author" value="${book.author}" required>
                </div>
                
                <div class="form-group">
                    <label for="isbn">ISBN</label>
                    <input type="text" class="form-control" id="isbn" name="isbn" value="${book.isbn}" required>
                </div>
                
                <div class="form-group">
                    <label for="publisher">Publisher</label>
                    <input type="text" class="form-control" id="publisher" name="publisher" value="${book.publisher}">
                </div>
                
                <div class="form-group">
                    <label for="publicationYear">Publication Year</label>
                    <input type="number" class="form-control" id="publicationYear" name="publicationYear" min="1000" max="2099" value="${book.publicationYear}">
                </div>
                
                <div class="form-group">
                    <label for="totalCopies">Total Copies</label>
                    <input type="number" class="form-control" id="totalCopies" name="totalCopies" min="1" value="${book.totalCopies}" required>
                </div>
                
                <div class="form-group">
                    <label for="availableCopies">Available Copies</label>
                    <input type="number" class="form-control" id="availableCopies" name="availableCopies" min="0" max="${book.totalCopies}" value="${book.availableCopies}" required>
                </div>
                
                <div class="form-actions">
                    <a href="${pageContext.request.contextPath}/admin/books" class="btn btn-secondary">Cancel</a>
                    <button type="submit" class="btn btn-primary">Save</button>
                </div>
            </form>
        </div>
    </div>
</body>
</html>