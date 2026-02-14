package com.mycompany.librarymanagementsystem.controller.auth;

import com.mycompany.librarymanagementsystem.dao.AdminDAO;
import com.mycompany.librarymanagementsystem.model.Admin;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/admin-register")
public class AdminRegisterController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private AdminDAO adminDAO;

    @Override
    public void init() throws ServletException {
        adminDAO = new AdminDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/auth/admin-register.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        // Basic validation
        if (name == null || name.isEmpty() ||
            email == null || email.isEmpty() ||
            username == null || username.isEmpty() ||
            password == null || password.isEmpty() ||
            confirmPassword == null || confirmPassword.isEmpty()) {

            request.setAttribute("errorMessage", "All fields are required");
            request.getRequestDispatcher("/auth/admin-register.jsp").forward(request, response);
            return;
        }

        // Email domain check
        if (!email.endsWith("@librarysystem.com")) {
            request.setAttribute("errorMessage", "Only official emails (e.g. user@librarysystem.com) are allowed");
            request.getRequestDispatcher("/auth/admin-register.jsp").forward(request, response);
            return;
        }

        if (!password.equals(confirmPassword)) {
            request.setAttribute("errorMessage", "Passwords do not match");
            request.getRequestDispatcher("/auth/admin-register.jsp").forward(request, response);
            return;
        }

        if (adminDAO.getAdminByUsername(username) != null) {
            request.setAttribute("errorMessage", "Username already taken");
            request.getRequestDispatcher("/auth/admin-register.jsp").forward(request, response);
            return;
        }

        Admin admin = new Admin();
        admin.setName(name);
        admin.setEmail(email);
        admin.setUsername(username);
        admin.setPassword(password); // Should be hashed in DAO

        boolean success = adminDAO.registerAdmin(admin);


        if (success) {
            request.setAttribute("successMessage", "Admin registered successfully. Please login.");
            request.getRequestDispatcher("/auth/admin-login.jsp").forward(request, response);
        } else {
            request.setAttribute("errorMessage", "Registration failed. Please try again.");
            request.getRequestDispatcher("/auth/admin-register.jsp").forward(request, response);
        }
    }
}