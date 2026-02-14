<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Library History - Library Management System</title>
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
            padding: 20px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.05);
        }
        
        .search-form {
            margin-bottom: 20px;
        }
        
        .search-input {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 16px;
            margin-bottom: 10px;
        }
        
        .history-table {
            width: 100%;
            border-collapse: collapse;
        }
        
        .history-table th {
            text-align: left;
            padding: 12px 15px;
            background-color: var(--cream);
            color: var(--brownie);
        }
        
        .history-table td {
            padding: 12px 15px;
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
            <li><a href="${pageContext.request.contextPath}/admin/return-books">Return Books</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/history" class="active">History</a></li>
            <li><a href="${pageContext.request.contextPath}/logout">Logout</a></li>
        </ul>
    </div>
    
    <div class="main-content">
        <div class="header">
            <h1 class="page-title">Library History</h1>
        </div>
        
        <div class="content-section">
            <div class="search-form">
                <input type="text" class="search-input" id="searchInput" placeholder="Search by book title, member name...">
            </div>
            
            <table class="history-table" id="historyTable">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Book</th>
                        <th>Member</th>
                        <th>Issue Date</th>
                        <th>Due Date</th>
                        <th>Return Date</th>
                        <th>Status</th>
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
        // Simple search functionality
        document.addEventListener('DOMContentLoaded', function() {
            const searchInput = document.getElementById('searchInput');
            const historyTable = document.getElementById('historyTable');
            
            searchInput.addEventListener('keyup', function() {
                const searchValue = this.value.toLowerCase();
                const rows = historyTable.getElementsByTagName('tr');
                
                // Start from index 1 to skip the header row
                for (let i = 1; i < rows.length; i++) {
                    const bookTitle = rows[i].getElementsByTagName('td')[1].textContent.toLowerCase();
                    const memberName = rows[i].getElementsByTagName('td')[2].textContent.toLowerCase();
                    
                    if (bookTitle.includes(searchValue) || memberName.includes(searchValue)) {
                        rows[i].style.display = '';
                    } else {
                        rows[i].style.display = 'none';
                    }
                }
            });
        });
    </script>
</body>
</html>