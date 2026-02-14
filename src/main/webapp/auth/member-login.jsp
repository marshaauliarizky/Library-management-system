<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Member Login - Library Management System</title>
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
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            padding: 20px;
        }
        
        .login-container {
            max-width: 400px;
            width: 100%;
        }
        
        .login-card {
            background-color: white;
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 6px 15px rgba(0, 0, 0, 0.1);
        }
        
        .card-header {
            background-color: var(--caramel);
            color: white;
            padding: 20px;
            text-align: center;
        }
        
        .logo {
            font-size: 40px;
            margin-bottom: 10px;
        }
        
        .title {
            font-size: 24px;
            margin-bottom: 5px;
        }
        
        .subtitle {
            font-size: 16px;
            opacity: 0.8;
        }
        
        .card-body {
            padding: 30px 20px;
        }
        
        .alert {
            padding: 10px 15px;
            border-radius: 4px;
            margin-bottom: 20px;
            font-size: 14px;
        }
        
        .alert-danger {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
        
        .alert-success {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
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
            padding: 12px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 16px;
        }
        
        .form-control:focus {
            border-color: var(--caramel);
            outline: none;
            box-shadow: 0 0 0 2px rgba(192, 133, 82, 0.2);
        }
        
        .btn {
            display: block;
            width: 100%;
            padding: 12px;
            border: none;
            border-radius: 4px;
            background-color: var(--caramel);
            color: white;
            font-size: 16px;
            font-weight: bold;
            cursor: pointer;
            transition: background-color 0.3s;
        }
        
        .btn:hover {
            background-color: #a6723f;
        }
        
        .card-footer {
            padding: 15px 20px;
            background-color: #f8f9fa;
            text-align: center;
            display: flex;
            justify-content: space-between;
        }
        
        .back-link, .register-link {
            color: var(--coffee);
            text-decoration: none;
            font-size: 14px;
            font-weight: bold;
        }
        
        .back-link:hover, .register-link:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <div class="login-container">
        <div class="login-card">
            <div class="card-header">
                <div class="logo">📚</div>
                <h1 class="title">Member Login</h1>
                <p class="subtitle">Library Management System</p>
            </div>
            
            <div class="card-body">
                <c:if test="${not empty errorMessage}">
                    <div class="alert alert-danger">
                        ${errorMessage}
                    </div>
                </c:if>
                
                <c:if test="${not empty successMessage}">
                    <div class="alert alert-success">
                        ${successMessage}
                    </div>
                </c:if>
                
                <form action="${pageContext.request.contextPath}/member-login" method="post">
                    <div class="form-group">
                        <label for="username">Username</label>
                        <input type="text" class="form-control" id="username" name="username" required autofocus>
                    </div>
                    
                    <div class="form-group">
                        <label for="password">Password</label>
                        <input type="password" class="form-control" id="password" name="password" required>
                    </div>
                    
                    <button type="submit" class="btn">Login</button>
                </form>
            </div>
            
            <div class="card-footer">
                <a href="${pageContext.request.contextPath}/" class="back-link">Back to Home</a>
                <a href="${pageContext.request.contextPath}/member-register" class="register-link">Register</a>
            </div>
        </div>
    </div>
</body>
</html>