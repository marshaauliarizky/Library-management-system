<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Books - Library Management System</title>
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
        
        .available {
            background-color: #2ecc71;
            color: white;
        }
        
        .borrowed {
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
        
        .view-btn {
            background-color: #2ecc71;
            color: white;
        }
        
        .view-btn:hover {
            background-color: #27ae60;
        }
        
        .highlighted {
            animation: highlight 3s ease-out;
        }
        
        @keyframes highlight {
            0% { background-color: #ffffcc; }
            100% { background-color: transparent; }
        }
        
        /* Modal Styles */
        .modal {
            display: none;
            position: fixed;
            z-index: 1000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            overflow: auto;
            background-color: rgba(0,0,0,0.4);
        }
        
        .modal-content {
            background-color: #fefefe;
            margin: 10% auto;
            padding: 20px;
            border: 1px solid #888;
            border-radius: 8px;
            width: 60%;
            max-width: 600px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
        }
        
        .modal-title {
            color: var(--brownie);
            margin-bottom: 20px;
            font-size: 20px;
            font-weight: bold;
        }
        
        .close {
            color: #aaa;
            float: right;
            font-size: 28px;
            font-weight: bold;
            cursor: pointer;
        }
        
        .close:hover,
        .close:focus {
            color: black;
            text-decoration: none;
        }
        
        .detail-row {
            margin-bottom: 10px;
        }
        
        .detail-label {
            font-weight: bold;
            color: var(--brownie);
        }
        
        .modal-actions {
            margin-top: 20px;
            text-align: right;
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
            
            .modal-content {
                width: 90%;
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
            <h1 class="page-title">Manage Books</h1>
            <a href="${pageContext.request.contextPath}/admin/books?action=add" class="btn btn-primary">Add New Book</a>
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
        
        <div class="search-bar">
            <input type="text" class="search-input" id="searchInput" placeholder="Search by title, author, or ISBN...">
        </div>
        
        <div class="content-section">
            <table class="books-table" id="booksTable">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Title</th>
                        <th>Synopsis</th>
                        <th>Author</th>
                        <th>ISBN</th>
                        <th>Copies</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="book" items="${books}">
                        <tr data-id="${book.id}" ${book.id == newBookId ? 'class="highlighted"' : ''}>
                            <td>${book.id}</td>
                            <td>${book.title}</td>
                            <td>${book.synopsis}</td>
                            <td>${book.author}</td>
                            <td>${book.isbn}</td>
                            <td>${book.availableCopies} / ${book.totalCopies}</td>
                            <td>
                                <span class="status-badge ${book.status == 'AVAILABLE' ? 'available' : 'borrowed'}">
                                    ${book.status}
                                </span>
                            </td>
                            <td class="actions">
                                <a href="${pageContext.request.contextPath}/admin/books?action=edit&id=${book.id}" class="action-btn edit-btn">Edit</a>
                                <a href="#" onclick="confirmDelete(${book.id}, '${book.title}')" class="action-btn delete-btn">Delete</a>
                                <a href="#" onclick="viewDetails(${book.id})" class="action-btn view-btn">View</a>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
    
    <!-- Book Details Modal -->
    <div id="bookDetailsModal" class="modal">
        <div class="modal-content">
            <span class="close" onclick="closeModal()">&times;</span>
            <h2 class="modal-title">Book Details</h2>
            <div id="bookDetailsContent">
                <div class="detail-row">
                    <span class="detail-label">Title:</span> <span id="book-title"></span>
                </div>
                <div class="detail-row">
                    <span class="detail-label">Synopsis:</span> <span id="book-synopsis"></span>
                </div>
                <div class="detail-row">
                    <span class="detail-label">Author:</span> <span id="book-author"></span>
                </div>
                <div class="detail-row">
                    <span class="detail-label">ISBN:</span> <span id="book-isbn"></span>
                </div>
                <div class="detail-row">
                    <span class="detail-label">Publisher:</span> <span id="book-publisher"></span>
                </div>
                <div class="detail-row">
                    <span class="detail-label">Publication Year:</span> <span id="book-publication-year"></span>
                </div>
                <div class="detail-row">
                    <span class="detail-label">Total Copies:</span> <span id="book-total-copies"></span>
                </div>
                <div class="detail-row">
                    <span class="detail-label">Available Copies:</span> <span id="book-available-copies"></span>
                </div>
                <div class="detail-row">
                    <span class="detail-label">Status:</span> <span id="book-status"></span>
                </div>
            </div>
            <div class="modal-actions">
                <button class="btn btn-secondary" onclick="closeModal()">Close</button>
            </div>
        </div>
    </div>
    
    <!-- Delete Confirmation Modal -->
    <div id="deleteModal" class="modal">
        <div class="modal-content">
            <span class="close" onclick="closeDeleteModal()">&times;</span>
            <h2 class="modal-title">Confirm Delete</h2>
            <p id="deleteMessage">Are you sure you want to delete this book?</p>
            <div class="modal-actions">
                <button class="btn btn-secondary" onclick="closeDeleteModal()">Cancel</button>
                <a href="#" id="confirmDeleteButton" class="btn btn-primary" style="background-color: #e74c3c;">Delete</a>
            </div>
        </div>
    </div>
    
    <script>
        // DOM Elements
        const searchInput = document.getElementById('searchInput');
        const booksTable = document.getElementById('booksTable');
        const bookDetailsModal = document.getElementById('bookDetailsModal');
        const deleteModal = document.getElementById('deleteModal');
        const deleteMessage = document.getElementById('deleteMessage');
        const confirmDeleteButton = document.getElementById('confirmDeleteButton');
        
        // Search functionality
        searchInput.addEventListener('keyup', function() {
            const searchValue = this.value.toLowerCase();
            const rows = booksTable.getElementsByTagName('tr');
            
            // Skip the header row (index 0)
            for (let i = 1; i < rows.length; i++) {
                const title = rows[i].getElementsByTagName('td')[1].textContent.toLowerCase();
                const author = rows[i].getElementsByTagName('td')[2].textContent.toLowerCase();
                const isbn = rows[i].getElementsByTagName('td')[3].textContent.toLowerCase();
                
                if (title.includes(searchValue) || author.includes(searchValue) || isbn.includes(searchValue)) {
                    rows[i].style.display = '';
                } else {
                    rows[i].style.display = 'none';
                }
            }
        });
        
        // View book details
        async function viewDetails(bookId) {
            try {
                const response = await fetch('${pageContext.request.contextPath}/admin/books?action=getDetails&id=' + bookId);
                if (!response.ok) {
                    throw new Error('Failed to fetch book details');
                }
                
                const book = await response.json();
                
                // Populate modal with book details
                document.getElementById('book-title').textContent = book.title || 'N/A';
                document.getElementById('book-synopsis').textContent = book.synopsis || 'N/A';
                document.getElementById('book-author').textContent = book.author || 'N/A';
                document.getElementById('book-isbn').textContent = book.isbn || 'N/A';
                document.getElementById('book-publisher').textContent = book.publisher || 'N/A';
                document.getElementById('book-publication-year').textContent = book.publicationYear || 'N/A';
                document.getElementById('book-total-copies').textContent = book.totalCopies || 'N/A';
                document.getElementById('book-available-copies').textContent = book.availableCopies || 'N/A';
                document.getElementById('book-status').textContent = book.status || 'N/A';
                
                // Show the modal
                bookDetailsModal.style.display = 'block';
            } catch (error) {
                console.error('Error:', error);
                alert('Failed to load book details. Please try again.');
            }
        }
        
        // Close book details modal
        function closeModal() {
            bookDetailsModal.style.display = 'none';
        }
        
        // Confirm delete
        function confirmDelete(bookId, bookTitle) {
            deleteMessage.textContent = `Are you sure you want to delete "${bookTitle}"?`;
            confirmDeleteButton.href = '${pageContext.request.contextPath}/admin/books?action=delete&id=' + bookId;
            deleteModal.style.display = 'block';
        }
        
        // Close delete modal
        function closeDeleteModal() {
            deleteModal.style.display = 'none';
        }
        
        // Close modal when clicking outside
        window.onclick = function(event) {
            if (event.target == bookDetailsModal) {
                closeModal();
            }
            if (event.target == deleteModal) {
                closeDeleteModal();
            }
        };
        
        // Highlight newly added or updated book
        document.addEventListener('DOMContentLoaded', function() {
            const highlightedRow = document.querySelector('tr.highlighted');
            if (highlightedRow) {
                highlightedRow.scrollIntoView({ behavior: 'smooth', block: 'center' });
            }
        });
    </script>
</body>
</html>