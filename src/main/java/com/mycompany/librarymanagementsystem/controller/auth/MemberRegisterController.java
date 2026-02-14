/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mycompany.librarymanagementsystem.controller.auth;

/**
 *
 * @author DMC_Studio
 */
import com.mycompany.librarymanagementsystem.dao.MemberDAO;
import com.mycompany.librarymanagementsystem.model.Member;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/member-register")
public class MemberRegisterController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private MemberDAO memberDAO;
    
    @Override
    public void init() throws ServletException {
        memberDAO = new MemberDAO();
    }
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Forward to registration page
        request.getRequestDispatcher("/auth/member-register.jsp").forward(request, response);
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String name = request.getParameter("name");
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String phoneNumber = request.getParameter("phoneNumber");
        
        // Validate input
        if (name == null || name.isEmpty() ||
            username == null || username.isEmpty() ||
            password == null || password.isEmpty() ||
            confirmPassword == null || confirmPassword.isEmpty() ||
            phoneNumber == null || phoneNumber.isEmpty()) {
            
            request.setAttribute("errorMessage", "All fields are required");
            request.getRequestDispatcher("/auth/member-register.jsp").forward(request, response);
            return;
        }
        
        // Check if passwords match
        if (!password.equals(confirmPassword)) {
            request.setAttribute("errorMessage", "Passwords do not match");
            request.getRequestDispatcher("/auth/member-register.jsp").forward(request, response);
            return;
        }
        
        // Check if username already exists
        if (memberDAO.getMemberByUsername(username) != null) {
            request.setAttribute("errorMessage", "Username already taken");
            request.getRequestDispatcher("/auth/member-register.jsp").forward(request, response);
            return;
        }
        
        // Create new member
        Member member = new Member();
        member.setName(name);
        member.setUsername(username);
        member.setPassword(password); // Will be hashed in DAO
        member.setPhoneNumber(phoneNumber);
        member.setStatus("ACTIVE");
        
        // Save member to database
        boolean success = memberDAO.addMember(member);
        
        if (success) {
            // Registration successful, redirect to login page
            request.getRequestDispatcher("/member/dashboard.jsp").forward(request, response);
        } else {
            // Registration failed
            request.setAttribute("errorMessage", "Registration failed. Please try again.");
            request.getRequestDispatcher("/auth/member-register.jsp").forward(request, response);
        }
    }
}
