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
import com.mycompany.librarymanagementsystem.util.SessionUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/member-login")
public class MemberLoginController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private MemberDAO memberDAO;
    
    @Override
    public void init() throws ServletException {
        memberDAO = new MemberDAO();
    }
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Check if member is already logged in
        if (SessionUtil.isMemberLoggedIn(request)) {
            response.sendRedirect(request.getContextPath() + "/member/dashboard");
            return;
        }
        
        // Forward to login page
        request.getRequestDispatcher("/auth/member-login.jsp").forward(request, response);
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        
        // Validate input
        if (username == null || username.isEmpty() || password == null || password.isEmpty()) {
            request.setAttribute("errorMessage", "Username and password are required");
            request.getRequestDispatcher("/auth/member-login.jsp").forward(request, response);
            return;
        }
        
        // Authenticate member
        Member member = memberDAO.authenticateMember(username, password);
        
        if (member != null) {
            // Authentication successful, store member in session
            SessionUtil.storeMemberInSession(request, member);
            response.sendRedirect(request.getContextPath() + "/member/dashboard");
        } else {
            // Authentication failed
            request.setAttribute("errorMessage", "Invalid username or password");
            request.getRequestDispatcher("/auth/member-login.jsp").forward(request, response);
        }
    }
}

