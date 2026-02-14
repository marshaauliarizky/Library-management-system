package com.mycompany.librarymanagementsystem.controller.member;

import com.mycompany.librarymanagementsystem.dao.BookDAO;
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
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.Timestamp;

import com.mycompany.librarymanagementsystem.util.DBConnection;

@WebServlet("/member/return-book")
public class ReturnBookController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private IssuedBookDAO issuedBookDAO;
    private BookDAO bookDAO;
    
    @Override
    public void init() throws ServletException {
        issuedBookDAO = new IssuedBookDAO();
        bookDAO = new BookDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Redirect ke halaman buku yang dipinjam
        response.sendRedirect(request.getContextPath() + "/member/issued-books");
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        System.out.println("=== MULAI PROSES PENGEMBALIAN BUKU ===");
        
        HttpSession session = request.getSession();
        String issuedBookIdParam = request.getParameter("issuedBookId");
        System.out.println("Parameter issuedBookId: " + issuedBookIdParam);
        
        // Validasi parameter
        if (issuedBookIdParam == null || issuedBookIdParam.isEmpty()) {
            System.out.println("ERROR: issuedBookId kosong");
            session.setAttribute("errorMessage", "ID Buku diperlukan");
            response.sendRedirect(request.getContextPath() + "/member/issued-books");
            return;
        }
        
        try {
            // Parse parameter
            int issuedBookId = Integer.parseInt(issuedBookIdParam);
            
            // Ambil data member dari session
            Member member = SessionUtil.getMemberFromSession(request);
            if (member == null) {
                System.out.println("ERROR: Member tidak ditemukan dalam session");
                response.sendRedirect(request.getContextPath() + "/member-login");
                return;
            }
            
            // Ambil data buku yang dipinjam
            IssuedBook issuedBook = issuedBookDAO.getIssuedBookById(issuedBookId);
            if (issuedBook == null) {
                System.out.println("ERROR: Data peminjaman tidak ditemukan");
                session.setAttribute("errorMessage", "Data peminjaman tidak ditemukan");
                response.sendRedirect(request.getContextPath() + "/member/issued-books");
                return;
            }
            
            // Verifikasi buku dipinjam oleh member yang login
            if (issuedBook.getMemberId() != member.getId()) {
                System.out.println("ERROR: Anda tidak memiliki hak untuk mengembalikan buku ini");
                session.setAttribute("errorMessage", "Anda tidak memiliki hak untuk mengembalikan buku ini");
                response.sendRedirect(request.getContextPath() + "/member/issued-books");
                return;
            }
            
            // Verifikasi buku belum dikembalikan
            if (!"NOT_RETURNED".equals(issuedBook.getReturnStatus())) {
                System.out.println("ERROR: Buku ini sudah dikembalikan");
                session.setAttribute("errorMessage", "Buku ini sudah dikembalikan");
                response.sendRedirect(request.getContextPath() + "/member/issued-books");
                return;
            }
            
            // Proses pengembalian buku
            boolean success = processReturnBook(issuedBookId, issuedBook.getBookId());
            
            if (success) {
                session.setAttribute("successMessage", "Buku berhasil dikembalikan");
            } else {
                session.setAttribute("errorMessage", "Gagal mengembalikan buku. Silakan coba lagi.");
            }
            
            // Redirect ke halaman buku yang dipinjam
            response.sendRedirect(request.getContextPath() + "/member/issued-books");
            
        } catch (NumberFormatException e) {
            System.out.println("ERROR: Format ID tidak valid - " + e.getMessage());
            session.setAttribute("errorMessage", "Format ID tidak valid");
            response.sendRedirect(request.getContextPath() + "/member/issued-books");
        } catch (Exception e) {
            System.out.println("ERROR: Terjadi exception tidak terduga - " + e.getMessage());
            e.printStackTrace();
            session.setAttribute("errorMessage", "Terjadi kesalahan: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/member/issued-books");
        }
        
        System.out.println("=== AKHIR PROSES PENGEMBALIAN BUKU ===");
    }
    
    private boolean processReturnBook(int issuedBookId, int bookId) {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);
            
            // Update status buku yang dipinjam
            boolean updatedIssuedBook = updateIssuedBookStatus(conn, issuedBookId);
            if (!updatedIssuedBook) {
                conn.rollback();
                return false;
            }
            
            // Update ketersediaan buku
            boolean updatedBookAvailability = updateBookAvailability(conn, bookId);
            if (!updatedBookAvailability) {
                conn.rollback();
                return false;
            }
            
            conn.commit();
            return true;
            
        } catch (SQLException | ClassNotFoundException e) {
            try {
                if (conn != null) {
                    conn.rollback();
                }
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            e.printStackTrace();
            return false;
        } finally {
            try {
                if (conn != null) {
                    conn.setAutoCommit(true);
                    conn.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
    
    private boolean updateIssuedBookStatus(Connection conn, int issuedBookId) throws SQLException {
        String sql = "UPDATE issued_books SET return_status = 'RETURNED', date_returned = CURRENT_TIMESTAMP WHERE id = ?";
        
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, issuedBookId);
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        }
    }
    
    private boolean updateBookAvailability(Connection conn, int bookId) throws SQLException {
        String sql = "UPDATE books SET available_copies = available_copies + 1, " +
                     "status = CASE WHEN available_copies + 1 > 0 THEN 'AVAILABLE' ELSE status END " +
                     "WHERE id = ?";
        
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, bookId);
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        }
    }
}