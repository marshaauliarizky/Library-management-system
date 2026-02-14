package com.mycompany.librarymanagementsystem.dao;

import com.mycompany.librarymanagementsystem.model.Book;
import com.mycompany.librarymanagementsystem.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BookDAO {
    
    /**
     * Get all books
     * @return List of all books
     */
    public List<Book> getAllBooks() {
        List<Book> books = new ArrayList<>();
        String sql = "SELECT * FROM books ORDER BY id DESC";
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                Book book = new Book();
                book.setId(rs.getInt("id"));
                book.setTitle(rs.getString("title"));
                book.setSynopsis(rs.getString("synopsis"));
                book.setAuthor(rs.getString("author"));
                book.setIsbn(rs.getString("isbn"));
                book.setPublicationYear(rs.getInt("publication_year"));
                book.setPublisher(rs.getString("publisher"));
                book.setAvailableCopies(rs.getInt("available_copies"));
                book.setTotalCopies(rs.getInt("total_copies"));
                book.setAddedDate(rs.getTimestamp("added_date"));
                book.setStatus(rs.getString("status"));
                books.add(book);
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        
        return books;
    }
    
    /**
     * Get books by title or author (search functionality)
     * @param keyword search keyword
     * @return List of matching books
     */
    public List<Book> searchBooks(String keyword) {
        List<Book> books = new ArrayList<>();
        String sql = "SELECT * FROM books WHERE title LIKE ? OR author LIKE ? OR isbn LIKE ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            String searchTerm = "%" + keyword + "%";
            stmt.setString(1, searchTerm);
            stmt.setString(2, searchTerm);
            stmt.setString(3, searchTerm);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Book book = new Book();
                    book.setId(rs.getInt("id"));
                    book.setTitle(rs.getString("title"));
                    book.setSynopsis(rs.getString("synopsis"));
                    book.setAuthor(rs.getString("author"));
                    book.setIsbn(rs.getString("isbn"));
                    book.setPublicationYear(rs.getInt("publication_year"));
                    book.setPublisher(rs.getString("publisher"));
                    book.setAvailableCopies(rs.getInt("available_copies"));
                    book.setTotalCopies(rs.getInt("total_copies"));
                    book.setAddedDate(rs.getTimestamp("added_date"));
                    book.setStatus(rs.getString("status"));
                    books.add(book);
                }
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        
        return books;
    }
    
    /**
     * Get a book by ID
     * @param id Book ID
     * @return Book object or null if not found
     */
    
    /**
 * Get the ID of the last inserted book
 * @return The ID of the last inserted book
 */
public int getLastInsertedId() {
    String sql = "SELECT MAX(id) FROM books";
    
    try (Connection conn = DBConnection.getConnection();
         Statement stmt = conn.createStatement();
         ResultSet rs = stmt.executeQuery(sql)) {
        
        if (rs.next()) {
            return rs.getInt(1);
        }
    } catch (SQLException | ClassNotFoundException e) {
        e.printStackTrace();
    }
    
    return 0;
}
    public Book getBookById(int id) {
        String sql = "SELECT * FROM books WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, id);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Book book = new Book();
                    book.setId(rs.getInt("id"));
                    book.setTitle(rs.getString("title"));
                    book.setSynopsis(rs.getString("synopsis"));
                    book.setAuthor(rs.getString("author"));
                    book.setIsbn(rs.getString("isbn"));
                    book.setPublicationYear(rs.getInt("publication_year"));
                    book.setPublisher(rs.getString("publisher"));
                    book.setAvailableCopies(rs.getInt("available_copies"));
                    book.setTotalCopies(rs.getInt("total_copies"));
                    book.setAddedDate(rs.getTimestamp("added_date"));
                    book.setStatus(rs.getString("status"));
                    return book;
                }
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        
        return null;
    }
    
    /**
     * Add a new book
     * @param book Book object to add
     * @return true if successful, false otherwise
     */
    
    /**
 * Get available books (status = AVAILABLE and available_copies > 0)
 * @return List of available books
 */
public List<Book> getAvailableBooks() {
    List<Book> books = new ArrayList<>();
    String sql = "SELECT * FROM books WHERE status = 'AVAILABLE' AND available_copies > 0 ORDER BY id DESC";
    
    try (Connection conn = DBConnection.getConnection();
         Statement stmt = conn.createStatement();
         ResultSet rs = stmt.executeQuery(sql)) {
        
        while (rs.next()) {
            Book book = new Book();
            book.setId(rs.getInt("id"));
            book.setTitle(rs.getString("title"));
            book.setSynopsis(rs.getString("synopsis"));
            book.setAuthor(rs.getString("author"));
            book.setIsbn(rs.getString("isbn"));
            book.setPublicationYear(rs.getInt("publication_year"));
            book.setPublisher(rs.getString("publisher"));
            book.setAvailableCopies(rs.getInt("available_copies"));
            book.setTotalCopies(rs.getInt("total_copies"));
            book.setAddedDate(rs.getTimestamp("added_date"));
            book.setStatus(rs.getString("status"));
            books.add(book);
        }
    } catch (SQLException | ClassNotFoundException e) {
        e.printStackTrace();
    }
    
    return books;
}
    public boolean addBook(Book book) {
        String sql = "INSERT INTO books (title, synopsis, author, isbn, publication_year, publisher, " +
                     "available_copies, total_copies, status) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, book.getTitle());
            stmt.setString(2, book.getSynopsis());
            stmt.setString(3, book.getAuthor());
            stmt.setString(4, book.getIsbn());
            stmt.setInt(5, book.getPublicationYear());
            stmt.setString(6, book.getPublisher());
            stmt.setInt(7, book.getAvailableCopies());
            stmt.setInt(8, book.getTotalCopies());
            stmt.setString(9, "AVAILABLE");
            
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Update a book
     * @param book Book object with updated values
     * @return true if successful, false otherwise
     */
    public boolean updateBook(Book book) {
        String sql = "UPDATE books SET title = ?, synopsis = ?, author = ?, isbn = ?, publication_year = ?, " +
                     "publisher = ?, available_copies = ?, total_copies = ?, status = ? WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, book.getTitle());
            stmt.setString(2, book.getSynopsis());
            stmt.setString(3, book.getAuthor());
            stmt.setString(4, book.getIsbn());
            stmt.setInt(5, book.getPublicationYear());
            stmt.setString(6, book.getPublisher());
            stmt.setInt(7, book.getAvailableCopies());
            stmt.setInt(8, book.getTotalCopies());
            stmt.setString(9, book.getStatus());
            stmt.setInt(10, book.getId());
            
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Delete a book
     * @param id Book ID to delete
     * @return true if successful, false otherwise
     */
    public boolean deleteBook(int id) {
        String sql = "DELETE FROM books WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, id);
            
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Update book status when issued or returned
     * @param bookId Book ID
     * @param isIssued true if book is being issued, false if being returned
     * @return true if successful, false otherwise
     */
    
       /**
     * Update book availability directly within the same connection
     * @param conn Database connection
     * @param bookId Book ID
     * @param isIssued true if being issued, false if being returned
     * @return true if successful
     */
    private boolean updateBookAvailabilityDirectly(Connection conn, int bookId, boolean isIssued) throws SQLException {
        String sql = "UPDATE books SET available_copies = available_copies " + 
                    (isIssued ? "- 1" : "+ 1") + 
                    ", status = CASE WHEN " + 
                    (isIssued ? "available_copies - 1 = 0" : "available_copies + 1 > 0") + 
                    " THEN " + 
                    (isIssued ? "'BORROWED'" : "'AVAILABLE'") + 
                    " ELSE status END WHERE id = ?";
        
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, bookId);
            int rowsAffected = stmt.executeUpdate();
            System.out.println("Update books: " + rowsAffected + " baris");
            return rowsAffected > 0;
        }
    }
    
    // Metode lain tetap sama seperti sebelumnya
    // Metode ini digunakan oleh controller untuk cek apakah buku sudah dipinjam
    public boolean isBookIssuedToMember(int bookId, int memberId) {
        String sql = "SELECT COUNT(*) FROM issued_books " +
                     "WHERE book_id = ? AND member_id = ? AND return_status = 'NOT_RETURNED'";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, bookId);
            stmt.setInt(2, memberId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        
        return false;
    }
public boolean updateBookAvailability(int bookId, boolean isIssued) {
    String sql = "UPDATE books SET available_copies = available_copies " + 
                 (isIssued ? "- 1" : "+ 1") + 
                 ", status = CASE WHEN " + 
                 (isIssued ? "available_copies - 1 <= 0" : "available_copies + 1 > 0") + 
                 " THEN " + 
                 (isIssued ? "'BORROWED'" : "'AVAILABLE'") + 
                 " ELSE status END WHERE id = ?";

    try (Connection conn = DBConnection.getConnection();
         PreparedStatement stmt = conn.prepareStatement(sql)) {

        stmt.setInt(1, bookId);
        int rowsAffected = stmt.executeUpdate();
        System.out.println(">> updateBookAvailability() - SQL Executed, rowsAffected: " + rowsAffected);
        
        // Force refresh status based on available copies
        if (rowsAffected > 0) {
            String refreshSql = "UPDATE books SET status = " +
                               "CASE WHEN available_copies <= 0 THEN 'BORROWED' ELSE 'AVAILABLE' END " +
                               "WHERE id = ?";
            try (PreparedStatement refreshStmt = conn.prepareStatement(refreshSql)) {
                refreshStmt.setInt(1, bookId);
                refreshStmt.executeUpdate();
            }
        }

        return rowsAffected > 0;
    } catch (SQLException | ClassNotFoundException e) {
        System.out.println(">> updateBookAvailability() - Exception: " + e.getMessage());
        e.printStackTrace();
        return false;
    }
}
    
    /**
     * Get total count of books
     * @return Total number of books
     */
    public int getTotalBooksCount() {
        String sql = "SELECT COUNT(*) FROM books";
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        
        return 0;
    }
    
    /**
     * Get count of borrowed books
     * @return Number of borrowed books
     */
    /**
 * Get count of borrowed books
 * @return Number of borrowed books
 */
public int getBorrowedBooksCount() {
    String sql = "SELECT COUNT(*) FROM issued_books WHERE return_status = 'NOT_RETURNED'";
    
    try (Connection conn = DBConnection.getConnection();
         Statement stmt = conn.createStatement();
         ResultSet rs = stmt.executeQuery(sql)) {
        
        if (rs.next()) {
            return rs.getInt(1);
        }
    } catch (SQLException | ClassNotFoundException e) {
        e.printStackTrace();
    }
    
    return 0;
}
}