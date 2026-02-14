<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<% 
    String error = (String) session.getAttribute("errorMessage");
    if (error != null) {
        out.println("<div style='color:red;'>" + error + "</div>");
        session.removeAttribute("errorMessage");
    }

    String success = (String) session.getAttribute("successMessage");
    if (success != null) {
        out.println("<div style='color:green;'>" + success + "</div>");
        session.removeAttribute("successMessage");
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Browse Books - Library Management System</title>
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
        
        .books-container {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 20px;
        }
        
        .book-card {
            background-color: white;
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.05);
            transition: transform 0.3s;
            display: flex;
            flex-direction: column;
        }
        
        .book-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 6px 12px rgba(0, 0, 0, 0.1);
        }
        
        .book-cover {
            height: 200px;
            background-color: var(--caramel);
            display: flex;
            justify-content: center;
            align-items: center;
            color: white;
            font-size: 18px;
            font-weight: bold;
            padding: 10px;
            text-align: center;
        }
        
        .book-info {
            padding: 20px;
            flex-grow: 1;
            display: flex;
            flex-direction: column;
        }
        
        .book-title {
            color: var(--brownie);
            font-size: 18px;
            font-weight: bold;
            margin-bottom: 10px;
        }
        
        .book-author {
            color: #666;
            margin-bottom: 15px;
            font-style: italic;
        }
        
        .book-details {
            margin-bottom: 15px;
            flex-grow: 1;
        }
        
        .book-detail {
            display: flex;
            margin-bottom: 5px;
        }
        
        .detail-label {
            font-weight: bold;
            margin-right: 10px;
            color: #333;
            flex: 1;
        }
        
        .detail-value {
            color: #666;
            flex: 2;
        }
        
        .book-status {
            margin-top: auto;
            display: flex;
            justify-content: space-between;
            align-items: center;
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
        
        .btn {
            padding: 8px 16px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 14px;
            font-weight: bold;
            text-decoration: none;
            transition: background-color 0.3s;
        }
        
        .btn-primary {
            background-color: var(--caramel);
            color: white;
        }
        
        .btn-primary:hover {
            background-color: #a6723f;
        }
        
        .btn-disabled {
            background-color: #ccc;
            color: #666;
            cursor: not-allowed;
        }
        
        .modal {
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
        
        .form-actions {
            margin-top: 20px;
            text-align: right;
        }
        
        .form-actions .btn {
            margin-left: 10px;
        }
        
        .empty-message {
            text-align: center;
            padding: 50px 0;
            color: #666;
            font-size: 18px;
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
            
            .books-container {
                grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
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
            <li><a href="${pageContext.request.contextPath}/member/books" class="active">Browse Books</a></li>
            <li><a href="${pageContext.request.contextPath}/member/issued-books">My Borrowed Books</a></li>
            <li><a href="${pageContext.request.contextPath}/member/history">My History</a></li>
            <li><a href="${pageContext.request.contextPath}/member/profile">My Profile</a></li>
            <li><a href="${pageContext.request.contextPath}/logout">Logout</a></li>
        </ul>
    </div>
    
    <div class="main-content">
        <div class="header">
            <h1 class="page-title">Browse Books</h1>
        </div>
        
        <div class="search-bar">
            <input type="text" class="search-input" id="book-search" placeholder="Search by title, author, or ISBN..." value="${param.search}">
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
        
        <c:choose>
            <c:when test="${empty books}">
                <div class="empty-message">
                    No books available at the moment.
                </div>
            </c:when>
            <c:otherwise>
                <div class="books-container">
                    <c:forEach var="book" items="${books}">
                        <div class="book-card">
                            <div class="book-cover">
                                ${book.title}
                            </div>
                            <div class="book-info">
                                <div class="book-title">${book.title}</div>
                                <div class="book-synopsis">${book.synopsis}</div>
                                <div class="book-author">by ${book.author}</div>
                                <div class="book-details">
                                    <div class="book-detail">
                                        <div class="detail-label">ISBN:</div>
                                        <div class="detail-value">${book.isbn}</div>
                                    </div>
                                    <div class="book-detail">
                                        <div class="detail-label">Publisher:</div>
                                        <div class="detail-value">${book.publisher}</div>
                                    </div>
                                    <div class="book-detail">
                                        <div class="detail-label">Year:</div>
                                        <div class="detail-value">${book.publicationYear}</div>
                                    </div>
                                    <div class="book-detail">
                                        <div class="detail-label">Available:</div>
                                        <div class="detail-value">${book.availableCopies}/${book.totalCopies}</div>
                                    </div>
                                </div>
                                <div class="book-status">
                                    <span class="status-badge ${book.status == 'AVAILABLE' ? 'available' : 'borrowed'}">
                                        ${book.status}
                                    </span>
                                    <c:choose>
                                        <c:when test="${book.status == 'AVAILABLE' && book.availableCopies > 0}">
                                            <form action="${pageContext.request.contextPath}/member/borrow-book" method="post" style="display:inline;">
                                                <input type="hidden" name="bookId" value="${book.id}">
                                                <button type="submit" class="btn btn-primary">Borrow</button>
                                            </form>
                                        </c:when>
                                        <c:otherwise>
                                            <button class="btn btn-disabled" disabled>Unavailable</button>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
    
    <!-- Borrow Confirmation Modal -->
<div id="borrow-modal" class="modal">
    <div class="modal-content">
        <span class="close-btn" onclick="closeModal()">&times;</span>
        <h2 class="modal-title">Borrow Book</h2>
        <p id="borrow-confirmation-message">Are you sure want to borrow this book?</p>
        <p><strong>Title :</strong> <span id="modal-book-title"></span></p>
        <p><strong>Synopsis :</strong> <span id="modal-book-synopsis"></span></p>
        <p><strong>Author : </strong> <span id="modal-book-author"></span></p>
        <p><strong>ISBN:</strong> <span id="modal-book-isbn"></span></p>
        <p><strong>Return Date:</strong> <span id="modal-due-date"></span></p>
        
        <form id="borrow-form" action="${pageContext.request.contextPath}/member/borrow-book" method="post">
            <input type="hidden" id="book-id" name="bookId">
            
            <div class="form-actions">
                <button type="button" class="btn" onclick="closeModal()">Cancel</button>
                <button type="button" class="btn btn-primary" onclick="submitBorrow()">Confirm</button>
            </div>
        </form>
    </div>
</div>
    
<script>
    // DOM Elements
    const modal = document.getElementById('borrow-modal');
    const closeBtn = document.querySelector('.close-btn');
    const borrowForm = document.getElementById('borrow-form');
    const bookIdInput = document.getElementById('book-id');
    const modalBookTitle = document.getElementById('modal-book-title');
    const modalBookSynopsis = document.getElementById('modal-book-synopsis');
    const modalBookAuthor = document.getElementById('modal-book-author');
    const modalBookISBN = document.getElementById('modal-book-isbn');
    const modalDueDate = document.getElementById('modal-due-date');
    const searchInput = document.getElementById('book-search');
    
    // Calculate due date (14 days from today)
    const dueDate = new Date();
    dueDate.setDate(dueDate.getDate() + 14);
    const formattedDueDate = dueDate.toISOString().split('T')[0];
    modalDueDate.textContent = formattedDueDate;
    
    // Functions
    function openBorrowModal(bookId, bookTitle,bookSynopsis, bookAuthor, bookISBN) {
        console.log("Modal dibuka untuk buku ID: " + bookId);

        bookIdInput.value = bookId;
        modalBookTitle.textContent = bookTitle;
        modalBookSynopsis.textContent = bookSynopsis;
        modalBookAuthor.textContent = bookAuthor;
        modalBookISBN.textContent = bookISBN;
        
        modal.style.display = 'block';
    }
    
    function closeModal() {
        modal.style.display = 'none';
    }
    
    function submitBorrow() {
        console.log("Form submit dengan book ID: " + bookIdInput.value);
        borrowForm.submit();
    }
    
    window.addEventListener('click', function(event) {
        if (event.target === modal) {
            closeModal();
        }
    });
    
    searchInput.addEventListener('keypress', function(e) {
        if (e.key === 'Enter') {
            const searchTerm = this.value.trim();
            if (searchTerm) {
                window.location.href = '${pageContext.request.contextPath}/member/books?search=' + encodeURIComponent(searchTerm);
            } else {
                window.location.href = '${pageContext.request.contextPath}/member/books';
            }
        }
    });
</script>
</body>
<c:if test="${not empty sessionScope.errorMessage}">
    <div style="color: red;">${sessionScope.errorMessage}</div>
    <c:remove var="errorMessage" scope="session" />
</c:if>

<c:if test="${not empty sessionScope.successMessage}">
    <div style="color: green;">${sessionScope.successMessage}</div>
    <c:remove var="successMessage" scope="session" />
</c:if>

</html>