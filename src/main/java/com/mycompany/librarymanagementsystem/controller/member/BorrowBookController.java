package com.mycompany.librarymanagementsystem.controller.member;

import com.mycompany.librarymanagementsystem.dao.BookDAO;
import com.mycompany.librarymanagementsystem.dao.IssuedBookDAO;
import com.mycompany.librarymanagementsystem.model.Book;
import com.mycompany.librarymanagementsystem.model.Member;
import com.mycompany.librarymanagementsystem.util.DateUtil;
import com.mycompany.librarymanagementsystem.util.SessionUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Timestamp;

@WebServlet("/member/borrow-book")
public class BorrowBookController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private BookDAO bookDAO;
    private IssuedBookDAO issuedBookDAO;
    
    @Override
    public void init() throws ServletException {
        bookDAO = new BookDAO();
        issuedBookDAO = new IssuedBookDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/member/books");
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Get member from session
        Member member = SessionUtil.getMemberFromSession(request);
        if (member == null) {
            response.sendRedirect(request.getContextPath() + "/member-login");
            return;
        }
        
        // Get book ID from parameter
        String bookIdParam = request.getParameter("bookId");
        if (bookIdParam == null || bookIdParam.isEmpty()) {
            request.getSession().setAttribute("errorMessage", "Invalid Book ID");
            response.sendRedirect(request.getContextPath() + "/member/books");
            return;
        }
        
        try {
            int bookId = Integer.parseInt(bookIdParam);
            
            // Get book data
            Book book = bookDAO.getBookById(bookId);
            if (book == null) {
                request.getSession().setAttribute("errorMessage", "Book not found");
                response.sendRedirect(request.getContextPath() + "/member/books");
                return;
            }
            
            // Check book availability
            if (book.getAvailableCopies() <= 0 || !"AVAILABLE".equals(book.getStatus())) {
                request.getSession().setAttribute("errorMessage", "Books are not available for borrowing");
                response.sendRedirect(request.getContextPath() + "/member/books");
                return;
            }
            
            // Calculate the return date (14 days from now)
            Timestamp dueDate = DateUtil.calculateDueDate();
            
            // Save loan data into database
            boolean success = issuedBookDAO.issueBook(bookId, member.getId(), dueDate);
            
            if (success) {
                // Reduce the number of books available
                book.setAvailableCopies(book.getAvailableCopies() - 1);
                if (book.getAvailableCopies() == 0) {
                    book.setStatus("BORROWED");
                }
                bookDAO.updateBook(book);
                
                request.getSession().setAttribute("successMessage", "The book was successfully borrowed. Please return it before" + 
                    DateUtil.formatDate(dueDate));
            } else {
                request.getSession().setAttribute("errorMessage", "Failed to borrow book. Please try again.");
            }
            
            response.sendRedirect(request.getContextPath() + "/member/dashboard");
            
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("errorMessage", "Invalid Book ID");
            response.sendRedirect(request.getContextPath() + "/member/books");
        } catch (Exception e) {
            request.getSession().setAttribute("errorMessage", "There is an error: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/member/books");
        }
    }
}