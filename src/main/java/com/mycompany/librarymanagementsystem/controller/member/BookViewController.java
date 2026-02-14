package com.mycompany.librarymanagementsystem.controller.member;

import com.mycompany.librarymanagementsystem.dao.BookDAO;
import com.mycompany.librarymanagementsystem.model.Book;
import com.mycompany.librarymanagementsystem.model.Member;
import com.mycompany.librarymanagementsystem.util.SessionUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

/**
 * Controller to display available books for members
 */
@WebServlet("/member/books")
public class BookViewController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private BookDAO bookDAO;
    
    @Override
    public void init() throws ServletException {
        bookDAO = new BookDAO();
    }
    
    /**
     * Handle HTTP GET requests
     * Display all books or search results
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        System.out.println("=== BookViewController.doGet START ===");
        
        // Check if member is logged in
        Member member = SessionUtil.getMemberFromSession(request);
        if (member == null) {
            System.out.println("Member tidak login, redirect ke halaman login");
            response.sendRedirect(request.getContextPath() + "/member-login");
            return;
        }
        
        // Check for messages from session
        HttpSession session = request.getSession();
        if (session.getAttribute("successMessage") != null) {
            request.setAttribute("successMessage", session.getAttribute("successMessage"));
            session.removeAttribute("successMessage");
            System.out.println("Pesan sukses ditemukan dan dipindahkan ke request attribute");
        }
        
        if (session.getAttribute("errorMessage") != null) {
            request.setAttribute("errorMessage", session.getAttribute("errorMessage"));
            session.removeAttribute("errorMessage");
            System.out.println("Pesan error ditemukan dan dipindahkan ke request attribute");
        }
        
        // Get search parameter
        String searchTerm = request.getParameter("search");
        System.out.println("Parameter pencarian: " + (searchTerm != null ? searchTerm : "tidak ada"));
        
        // Get books based on search term
        List<Book> books;
        if (searchTerm != null && !searchTerm.isEmpty()) {
            books = bookDAO.searchBooks(searchTerm);
            request.setAttribute("searchTerm", searchTerm);
            System.out.println("Melakukan pencarian buku dengan kata kunci: " + searchTerm);
        } else {
            books = bookDAO.getAllBooks();
            System.out.println("Mengambil semua buku");
        }
        
        System.out.println("Jumlah buku yang ditemukan: " + books.size());
        
        // Set books attribute
        request.setAttribute("books", books);
        
        // Log books for debugging
        if (books.size() < 10) { // Hanya log jika jumlah buku tidak terlalu banyak
            for (Book book : books) {
                System.out.println("Buku: " + book.getTitle() + ", Status: " + book.getStatus() + 
                                  ", Copies: " + book.getAvailableCopies() + "/" + book.getTotalCopies());
            }
        }
        
        // Forward to books page
        System.out.println("Forward ke /member/books.jsp");
        request.getRequestDispatcher("/member/books.jsp").forward(request, response);
        
        System.out.println("=== BookViewController.doGet END ===");
    }
    
    /**
     * Handle HTTP POST requests
     * Just redirect to GET
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        System.out.println("=== BookViewController.doPost: redirect ke doGet ===");
        doGet(request, response);
    }
}