package com.mycompany.librarymanagementsystem.controller.admin;

import com.mycompany.librarymanagementsystem.dao.BookDAO;
import com.mycompany.librarymanagementsystem.dao.MemberDAO;
import com.mycompany.librarymanagementsystem.model.Admin;
import com.mycompany.librarymanagementsystem.model.Book;
import com.mycompany.librarymanagementsystem.model.Member;
import com.mycompany.librarymanagementsystem.util.SessionUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/admin/search")
public class SearchController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private BookDAO bookDAO;
    private MemberDAO memberDAO;
    
    @Override
    public void init() throws ServletException {
        bookDAO = new BookDAO();
        memberDAO = new MemberDAO();
    }
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Cek apakah admin sudah login
        Admin admin = SessionUtil.getAdminFromSession(request);
        if (admin == null) {
            response.sendRedirect(request.getContextPath() + "/admin-login");
            return;
        }
        
        // Ambil parameter pencarian
        String term = request.getParameter("term");
        
        if (term == null || term.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            return;
        }
        
        // Cari buku dan anggota yang sesuai
        List<Book> books = bookDAO.searchBooks(term);
        List<Member> members = memberDAO.searchMembers(term);
        
        // Set atribut hasil pencarian
        request.setAttribute("searchTerm", term);
        request.setAttribute("books", books);
        request.setAttribute("members", members);
        
        // Forward ke halaman hasil pencarian
        request.getRequestDispatcher("/admin/search-results.jsp").forward(request, response);
    }
}