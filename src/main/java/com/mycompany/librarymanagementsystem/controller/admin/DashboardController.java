package com.mycompany.librarymanagementsystem.controller.admin;

import com.mycompany.librarymanagementsystem.dao.BookDAO;
import com.mycompany.librarymanagementsystem.dao.IssuedBookDAO;
import com.mycompany.librarymanagementsystem.dao.MemberDAO;
import com.mycompany.librarymanagementsystem.model.Admin;
import com.mycompany.librarymanagementsystem.model.IssuedBook;
import com.mycompany.librarymanagementsystem.util.SessionUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Date;
import java.util.List;

@WebServlet("/admin/dashboard")
public class DashboardController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private BookDAO bookDAO;
    private MemberDAO memberDAO;
    private IssuedBookDAO issuedBookDAO;
    
    @Override
    public void init() throws ServletException {
        bookDAO = new BookDAO();
        memberDAO = new MemberDAO();
        issuedBookDAO = new IssuedBookDAO();
    }
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Admin admin = SessionUtil.getAdminFromSession(request);
        if (admin == null) {
            response.sendRedirect(request.getContextPath() + "/admin-login");
            return;
        }
        
        int totalBooks = bookDAO.getTotalBooksCount();
        int totalMembers = memberDAO.getTotalMembersCount();
        int borrowedBooks = bookDAO.getBorrowedBooksCount();
        int overdueBooks = issuedBookDAO.getOverdueBooks().size();
        
        List<IssuedBook> recentActivityBooks = issuedBookDAO.getAllIssuedBooks();
        if (recentActivityBooks.size() > 5) {
            recentActivityBooks = recentActivityBooks.subList(0, 5);
        }
        
        request.setAttribute("now", new Date());
        
        request.setAttribute("totalBooks", totalBooks);
        request.setAttribute("totalMembers", totalMembers);
        request.setAttribute("borrowedBooks", borrowedBooks);
        request.setAttribute("overdueBooks", overdueBooks);
        request.setAttribute("recentActivityBooks", recentActivityBooks);
        
        request.getRequestDispatcher("/admin/dashboard.jsp").forward(request, response);
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
