<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Library Management System</title>
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
        
        .container {
            max-width: 800px;
            width: 100%;
        }
        
        .welcome-card {
            background-color: white;
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 6px 15px rgba(0, 0, 0, 0.1);
            text-align: center;
        }
        
        .card-header {
            background-color: var(--brownie);
            color: white;
            padding: 30px 20px;
        }
        
        .logo {
            font-size: 60px;
            margin-bottom: 20px;
        }
        
        .title {
            font-size: 32px;
            margin-bottom: 10px;
        }
        
        .subtitle {
            font-size: 18px;
            opacity: 0.8;
        }
        
        .card-body {
            padding: 40px 20px;
        }
        
        .btn-container {
            display: flex;
            flex-direction: column;
            gap: 15px;
            max-width: 300px;
            margin: 0 auto;
        }
        
        .btn {
            display: block;
            padding: 15px;
            border: none;
            border-radius: 5px;
            font-size: 18px;
            font-weight: bold;
            text-align: center;
            text-decoration: none;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        
        .btn-admin {
            background-color: var(--brownie);
            color: white;
        }
        
        .btn-admin:hover {
            background-color: #4a261c;
        }
        
        .btn-member {
            background-color: var(--caramel);
            color: white;
        }
        
        .btn-member:hover {
            background-color: #a67345;
        }
        
        .card-footer {
            padding: 20px;
            background-color: #f8f9fa;
            font-size: 14px;
            color: #666;
        }
        
        @media (max-width: 500px) {
            .title {
                font-size: 28px;
            }
            
            .subtitle {
                font-size: 16px;
            }
            
            .btn {
                font-size: 16px;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="welcome-card">
            <div class="card-header">
                <div class="logo">📚</div>
                <h1 class="title">Library Management System</h1>
                <p class="subtitle">Manage your library efficiently</p>
            </div>
            
            <div class="card-body">
                <div class="btn-container">
                    <a href="${pageContext.request.contextPath}/admin-login" class="btn btn-admin">Login as Admin</a>
                    <a href="${pageContext.request.contextPath}/member-login" class="btn btn-member">Login as Member</a>
                </div>
            </div>
            
            <div class="card-footer">
                &copy; 2025 Library Management System | All Rights Reserved
            </div>
        </div>
    </div>
</body>
</html>