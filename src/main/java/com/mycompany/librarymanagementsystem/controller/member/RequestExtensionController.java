package com.mycompany.librarymanagementsystem.controller.member;

import com.mycompany.librarymanagementsystem.dao.IssuedBookDAO;
import com.mycompany.librarymanagementsystem.model.IssuedBook;
import com.mycompany.librarymanagementsystem.model.Member;
import com.mycompany.librarymanagementsystem.util.SessionUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/member/request-extension")
public class RequestExtensionController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private IssuedBookDAO issuedBookDAO;
    
    @Override
    public void init() throws ServletException {
        issuedBookDAO = new IssuedBookDAO();
    }
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Redirect to dashboard by default
        response.sendRedirect(request.getContextPath() + "/member/dashboard");
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Get member from session
        Member member = SessionUtil.getMemberFromSession(request);
        if (member == null) {
            response.sendRedirect(request.getContextPath() + "/member-login");
            return;
        }
        
        // Get issued book ID
        String issuedBookIdParam = request.getParameter("issuedBookId");
        
        // Get return URL (source page)
        String returnUrl = request.getParameter("returnUrl");
        if (returnUrl == null || returnUrl.isEmpty()) {
            // Default return URL if not specified
            returnUrl = "/member/dashboard";
        }
        
        if (issuedBookIdParam == null || issuedBookIdParam.isEmpty()) {
            // Store error message in session to preserve after redirect
            request.getSession().setAttribute("errorMessage", "Book ID is required");
            response.sendRedirect(request.getContextPath() + returnUrl);
            return;
        }
        
        try {
            int issuedBookId = Integer.parseInt(issuedBookIdParam);
            
            // Verify that the issued book belongs to the member
            IssuedBook issuedBook = issuedBookDAO.getIssuedBookById(issuedBookId);
            
            if (issuedBook == null || issuedBook.getMemberId() != member.getId()) {
                // Store error message in session
                request.getSession().setAttribute("errorMessage", 
                    "Invalid book or you don't have permission to request extension for this book");
                response.sendRedirect(request.getContextPath() + returnUrl);
                return;
            }
            
            // Check if extension is already requested or approved
            if (!"NONE".equals(issuedBook.getExtensionStatus()) && !"REJECTED".equals(issuedBook.getExtensionStatus())) {
                // Store error message in session
                request.getSession().setAttribute("errorMessage", 
                    "Extension already " + issuedBook.getExtensionStatus().toLowerCase());
                response.sendRedirect(request.getContextPath() + returnUrl);
                return;
            }
            
            // Request extension
            boolean success = issuedBookDAO.requestExtension(issuedBookId);
            
            if (success) {
                // Store success message in session
                request.getSession().setAttribute("successMessage", "Extension requested successfully");
            } else {
                // Store error message in session
                request.getSession().setAttribute("errorMessage", "Failed to request extension. Please try again.");
            }
            
            // Redirect back to the source page
            response.sendRedirect(request.getContextPath() + returnUrl);
            
        } catch (NumberFormatException e) {
            // Store error message in session
            request.getSession().setAttribute("errorMessage", "Invalid book ID");
            response.sendRedirect(request.getContextPath() + returnUrl);
        }
    }
}