package com.mycompany.librarymanagementsystem.controller.member;

import com.mycompany.librarymanagementsystem.dao.MemberDAO;
import com.mycompany.librarymanagementsystem.model.Member;
import com.mycompany.librarymanagementsystem.util.SessionUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/member/profile")
public class ProfileController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private MemberDAO memberDAO;
    
    @Override
    public void init() throws ServletException {
        memberDAO = new MemberDAO();
    }
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Get member from session
        Member member = SessionUtil.getMemberFromSession(request);
        if (member == null) {
            response.sendRedirect(request.getContextPath() + "/member-login");
            return;
        }
        
        // Set member attribute
        request.setAttribute("member", member);
        
        // Forward to profile page
        request.getRequestDispatcher("/member/profile.jsp").forward(request, response);
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Get member from session
        Member member = SessionUtil.getMemberFromSession(request);
        if (member == null) {
            response.sendRedirect(request.getContextPath() + "/member-login");
            return;
        }
        
        // Get form data
        String name = request.getParameter("name");
        String username = request.getParameter("username");
        String phoneNumber = request.getParameter("phoneNumber");
        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");
        
        // Validate input
        if (name == null || name.isEmpty() ||
            username == null || username.isEmpty() ||
            phoneNumber == null || phoneNumber.isEmpty()) {
            
            request.setAttribute("errorMessage", "Name, username, and phone number are required");
            request.setAttribute("member", member);
            request.getRequestDispatcher("/member/profile.jsp").forward(request, response);
            return;
        }
        
        // Check if username already exists (if changed)
        if (!username.equals(member.getUsername())) {
            Member existingMember = memberDAO.getMemberByUsername(username);
            if (existingMember != null) {
                request.setAttribute("errorMessage", "Username already taken");
                request.setAttribute("member", member);
                request.getRequestDispatcher("/member/profile.jsp").forward(request, response);
                return;
            }
        }
        
        // Update member object
        member.setName(name);
        member.setUsername(username);
        member.setPhoneNumber(phoneNumber);
        
        // Check if password needs to be updated
        boolean updatePassword = false;
        
        if (currentPassword != null && !currentPassword.isEmpty() &&
            newPassword != null && !newPassword.isEmpty() &&
            confirmPassword != null && !confirmPassword.isEmpty()) {
            
            // Verify current password
            Member authMember = memberDAO.authenticateMember(member.getUsername(), currentPassword);
            if (authMember == null) {
                request.setAttribute("errorMessage", "Current password is incorrect");
                request.setAttribute("member", member);
                request.getRequestDispatcher("/member/profile.jsp").forward(request, response);
                return;
            }
            
            // Check if new passwords match
            if (!newPassword.equals(confirmPassword)) {
                request.setAttribute("errorMessage", "New passwords do not match");
                request.setAttribute("member", member);
                request.getRequestDispatcher("/member/profile.jsp").forward(request, response);
                return;
            }
            
            // Set new password
            member.setPassword(newPassword);
            updatePassword = true;
        }
        
        // Update member in database
        boolean success = memberDAO.updateMember(member, updatePassword);
        
        if (success) {
            // Update member in session
            SessionUtil.storeMemberInSession(request, member);
            request.setAttribute("successMessage", "Profile updated successfully");
        } else {
            request.setAttribute("errorMessage", "Failed to update profile. Please try again.");
        }
        
        request.setAttribute("member", member);
        request.getRequestDispatcher("/member/profile.jsp").forward(request, response);
    }
}