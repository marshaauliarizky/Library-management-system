package com.mycompany.librarymanagementsystem.test;

import com.mycompany.librarymanagementsystem.dao.BookDAO;
import com.mycompany.librarymanagementsystem.model.Book;
import com.mycompany.librarymanagementsystem.model.Member;
import com.mycompany.librarymanagementsystem.util.DateUtil;
import com.mycompany.librarymanagementsystem.util.DBConnection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.Timestamp;

/**
 * Test servlet untuk melakukan peminjaman buku tanpa melalui UI
 * Akses melalui: /test-borrow?bookId=1&memberId=1
 */
@WebServlet("/test-borrow")
public class TestBorrowServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        
        out.println("<!DOCTYPE html>");
        out.println("<html>");
        out.println("<head><title>Test Peminjaman Buku</title></head>");
        out.println("<body>");
        out.println("<h1>Test Peminjaman Buku</h1>");
        
        try {
            // Ambil parameter
            String bookIdParam = request.getParameter("bookId");
            String memberIdParam = request.getParameter("memberId");
            
            if (bookIdParam == null || memberIdParam == null) {
                out.println("<p>Parameter tidak lengkap. Gunakan: /test-borrow?bookId=X&memberId=Y</p>");
                return;
            }
            
            int bookId = Integer.parseInt(bookIdParam);
            int memberId = Integer.parseInt(memberIdParam);
            
            // Validasi buku
            BookDAO bookDAO = new BookDAO();
            Book book = bookDAO.getBookById(bookId);
            
            if (book == null) {
                out.println("<p style='color:red'>Buku tidak ditemukan!</p>");
                return;
            }
            
            out.println("<p>Buku: " + book.getTitle() + " (ID: " + book.getId() + ")</p>");
            out.println("<p>Member ID: " + memberId + "</p>");
            
            // Tanggal pengembalian
            Timestamp dueDate = DateUtil.calculateDueDate();
            out.println("<p>Tanggal Pengembalian: " + DateUtil.formatDate(dueDate) + "</p>");
            
            // Lakukan peminjaman langsung
            boolean success = insertIssuedBookDirectly(bookId, memberId, dueDate);
            
            if (success) {
                out.println("<p style='color:green;font-weight:bold'>PEMINJAMAN BERHASIL!</p>");
                
                // Update stok buku
                book.setAvailableCopies(book.getAvailableCopies() - 1);
                if (book.getAvailableCopies() == 0) {
                    book.setStatus("BORROWED");
                }
                boolean updated = bookDAO.updateBook(book);
                
                if (updated) {
                    out.println("<p>Stok buku berhasil diperbarui.</p>");
                } else {
                    out.println("<p style='color:orange'>Peminjaman berhasil tapi gagal update stok buku.</p>");
                }
            } else {
                out.println("<p style='color:red;font-weight:bold'>PEMINJAMAN GAGAL! Lihat log server.</p>");
            }
            
        } catch (NumberFormatException e) {
            out.println("<p style='color:red'>Error: Format ID tidak valid</p>");
            out.println("<pre>" + e.getMessage() + "</pre>");
        } catch (Exception e) {
            out.println("<p style='color:red'>Error: " + e.getMessage() + "</p>");
            out.println("<pre>");
            e.printStackTrace(out);
            out.println("</pre>");
        }
        
        out.println("</body>");
        out.println("</html>");
    }
    
    private boolean insertIssuedBookDirectly(int bookId, int memberId, Timestamp dueDate) throws SQLException, ClassNotFoundException {
        String sql = "INSERT INTO issued_books (book_id, member_id, due_date) VALUES (?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection()) {
            conn.setAutoCommit(false);
            
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setInt(1, bookId);
                stmt.setInt(2, memberId);
                stmt.setTimestamp(3, dueDate);
                
                int rowsAffected = stmt.executeUpdate();
                
                if (rowsAffected > 0) {
                    conn.commit();
                    return true;
                } else {
                    conn.rollback();
                    return false;
                }
            } catch (SQLException e) {
                conn.rollback();
                throw e;
            } finally {
                conn.setAutoCommit(true);
            }
        }
    }
}