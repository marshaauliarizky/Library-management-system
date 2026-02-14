/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mycompany.librarymanagementsystem.controller.auth;

/**
 *
 * @author DMC_Studio
 */
import com.mycompany.librarymanagementsystem.dao.AdminDAO;
import com.mycompany.librarymanagementsystem.model.Admin;
import com.mycompany.librarymanagementsystem.util.SessionUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/admin-login")
public class AdminLoginController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private AdminDAO adminDAO;
    
    @Override
    public void init() throws ServletException {
        adminDAO = new AdminDAO();
    }
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Check if admin is already logged in
        if (SessionUtil.isAdminLoggedIn(request)) {
            response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            return;
        }
        
        // Forward to login page
        request.getRequestDispatcher("/auth/admin-login.jsp").forward(request, response);
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        
        // Validate input
        if (username == null || username.isEmpty() || password == null || password.isEmpty()) {
            request.setAttribute("errorMessage", "Username and password are required");
            request.getRequestDispatcher("/auth/admin-login.jsp").forward(request, response);
            return;
        }
        
        // Authenticate admin
        Admin admin = adminDAO.authenticateAdmin(username, password);
        
        if (admin != null) {
            // Authentication successful, store admin in session
            SessionUtil.storeAdminInSession(request, admin);
            response.sendRedirect(request.getContextPath() + "/admin/dashboard");
        } else {
            // Authentication failed
            request.setAttribute("errorMessage", "Invalid username or password");
            request.getRequestDispatcher("/auth/admin-login.jsp").forward(request, response);
        }
    }
}
