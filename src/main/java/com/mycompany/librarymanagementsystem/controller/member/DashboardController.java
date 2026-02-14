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
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/member/dashboard")
public class DashboardController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private IssuedBookDAO issuedBookDAO;
    
    @Override
    public void init() throws ServletException {
        issuedBookDAO = new IssuedBookDAO();
    }
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Get member from session
        Member member = SessionUtil.getMemberFromSession(request);
        if (member == null) {
            response.sendRedirect(request.getContextPath() + "/member-login");
            return;
        }
        
        // Check for session messages and transfer them to request attributes
        HttpSession session = request.getSession();
        if (session.getAttribute("successMessage") != null) {
            request.setAttribute("successMessage", session.getAttribute("successMessage"));
            session.removeAttribute("successMessage");
        }
        
        if (session.getAttribute("errorMessage") != null) {
            request.setAttribute("errorMessage", session.getAttribute("errorMessage"));
            session.removeAttribute("errorMessage");
        }
        
        // Get current timestamp
        Timestamp now = new Timestamp(System.currentTimeMillis());
        request.setAttribute("now", now);
        
        // Get member's issued books
        List<IssuedBook> issuedBooks = issuedBookDAO.getIssuedBooksByMember(member.getId());
        
        // Get currently borrowed books (not returned)
        List<IssuedBook> currentlyBorrowedBooks = new ArrayList<>();
        int overdueCount = 0;
        
        for (IssuedBook book : issuedBooks) {
            if ("NOT_RETURNED".equals(book.getReturnStatus())) {
                currentlyBorrowedBooks.add(book);
                
                // Check if overdue
                if (book.getDueDate().before(now)) {
                    overdueCount++;
                }
            }
        }
        
        // Set attributes
        request.setAttribute("currentlyBorrowed", currentlyBorrowedBooks.size());
        request.setAttribute("totalBorrowed", issuedBooks.size());
        request.setAttribute("overdueBooks", overdueCount);
        request.setAttribute("currentlyBorrowedBooks", currentlyBorrowedBooks);
        
        // Forward to dashboard page
        request.getRequestDispatcher("/member/dashboard.jsp").forward(request, response);
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}