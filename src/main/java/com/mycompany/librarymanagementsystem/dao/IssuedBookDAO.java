/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mycompany.librarymanagementsystem.dao;

/**
 *
 * @author DMC_Studio
 */
import com.mycompany.librarymanagementsystem.model.IssuedBook;
import com.mycompany.librarymanagementsystem.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;

public class IssuedBookDAO {
    
    /**
     * Issue a book to a member
     * @param bookId Book ID
     * @param memberId Member ID
     * @param dueDate Due date for return
     * @return true if successful, false otherwise
     */
public boolean issueBook(int bookId, int memberId, Timestamp dueDate) {
    String sql = "INSERT INTO issued_books (book_id, member_id, due_date, return_status, extension_status) " +
                 "VALUES (?, ?, ?, 'NOT_RETURNED', 'NONE')";

    try (Connection conn = DBConnection.getConnection()) {
        // Start transaction
        conn.setAutoCommit(false);
        
        try {
            // Periksa ketersediaan buku
            try (PreparedStatement checkStmt = conn.prepareStatement(
                    "SELECT available_copies FROM books WHERE id = ?")) {
                checkStmt.setInt(1, bookId);
                try (ResultSet rs = checkStmt.executeQuery()) {
                    if (!rs.next() || rs.getInt("available_copies") <= 0) {
                        System.out.println("Buku tidak tersedia untuk dipinjam");
                        conn.rollback();
                        return false;
                    }
                }
            }
            
            // Insert record peminjaman
            try (PreparedStatement issueStmt = conn.prepareStatement(sql)) {
                issueStmt.setInt(1, bookId);
                issueStmt.setInt(2, memberId);
                issueStmt.setTimestamp(3, dueDate);
               
                int rowsAffected = issueStmt.executeUpdate();
                System.out.println(">> INSERT issued_books: " + rowsAffected + " row(s)");
    
                if (rowsAffected <= 0) {
                    System.out.println(">> Gagal menambahkan record peminjaman");
                    conn.rollback();
                    return false;
                }
            }
            
            // Update ketersediaan buku
            try (PreparedStatement updateStmt = conn.prepareStatement(
                    "UPDATE books SET available_copies = available_copies - 1, " +
                    "status = CASE WHEN available_copies - 1 <= 0 THEN 'BORROWED' ELSE 'AVAILABLE' END " +
                    "WHERE id = ?")) {
                updateStmt.setInt(1, bookId);
                int updateRows = updateStmt.executeUpdate();
                
                if (updateRows <= 0) {
                    System.out.println(">> Gagal update ketersediaan buku");
                    conn.rollback();
                    return false;
                }
            }
            
            // Commit transaksi jika semua berhasil
            conn.commit();
            System.out.println(">> Transaksi sukses dan commit");
            return true;
            
        } catch (SQLException e) {
            conn.rollback();
            System.out.println(">> Exception SQL: " + e.getMessage());
            e.printStackTrace();
            return false;
        } finally {
            // Kembalikan ke mode auto-commit
            try {
                conn.setAutoCommit(true);
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    } catch (SQLException | ClassNotFoundException e) {
        System.out.println(">> Exception koneksi DB: " + e.getMessage());
        e.printStackTrace();
        return false;
    }
}

/**
 * Get all returned books
 * @return List of returned books
 */
public List<IssuedBook> getReturnedBooks() {
    List<IssuedBook> returnedBooks = new ArrayList<>();
    String sql = "SELECT i.*, b.title as book_title, m.name as member_name " +
                 "FROM issued_books i " +
                 "JOIN books b ON i.book_id = b.id " +
                 "JOIN members m ON i.member_id = m.id " +
                 "WHERE i.return_status = 'RETURNED' " +
                 "ORDER BY i.date_returned DESC";
    
    try (Connection conn = DBConnection.getConnection();
         Statement stmt = conn.createStatement();
         ResultSet rs = stmt.executeQuery(sql)) {
        
        while (rs.next()) {
            IssuedBook issuedBook = mapIssuedBookFromResultSet(rs);
            returnedBooks.add(issuedBook);
        }
    } catch (SQLException | ClassNotFoundException e) {
        e.printStackTrace();
    }
    
    return returnedBooks;
}

/**
 * Get books with extension requests
 * @return List of books with extension requests
 */
public List<IssuedBook> getExtensionRequests() {
    List<IssuedBook> extensionRequests = new ArrayList<>();
    String sql = "SELECT i.*, b.title as book_title, m.name as member_name " +
                 "FROM issued_books i " +
                 "JOIN books b ON i.book_id = b.id " +
                 "JOIN members m ON i.member_id = m.id " +
                 "WHERE i.extension_status = 'REQUESTED' " +
                 "ORDER BY i.date_issued DESC";
    
    try (Connection conn = DBConnection.getConnection();
         Statement stmt = conn.createStatement();
         ResultSet rs = stmt.executeQuery(sql)) {
        
        while (rs.next()) {
            IssuedBook issuedBook = mapIssuedBookFromResultSet(rs);
            extensionRequests.add(issuedBook);
        }
    } catch (SQLException | ClassNotFoundException e) {
        e.printStackTrace();
    }
    
    return extensionRequests;
}

// Helper method untuk mapping ResultSet ke objek IssuedBook
private IssuedBook mapIssuedBookFromResultSet(ResultSet rs) throws SQLException {
    IssuedBook issuedBook = new IssuedBook();
    issuedBook.setId(rs.getInt("id"));
    issuedBook.setBookId(rs.getInt("book_id"));
    issuedBook.setMemberId(rs.getInt("member_id"));
    issuedBook.setDateIssued(rs.getTimestamp("date_issued"));
    issuedBook.setDueDate(rs.getTimestamp("due_date"));
    issuedBook.setDateReturned(rs.getTimestamp("date_returned"));
    issuedBook.setReturnStatus(rs.getString("return_status"));
    issuedBook.setExtensionStatus(rs.getString("extension_status"));
    issuedBook.setBookTitle(rs.getString("book_title"));
    issuedBook.setMemberName(rs.getString("member_name"));
    return issuedBook;
}
/**
 * Get recent issued books ordered by issue date
 * @param limit Maximum number of records to return
 * @return List of recently issued books
 */
public List<IssuedBook> getRecentIssuedBooks(int limit) {
    List<IssuedBook> recentBooks = new ArrayList<>();
    String sql = "SELECT i.*, b.title as book_title, m.name as member_name " +
                 "FROM issued_books i " +
                 "JOIN books b ON i.book_id = b.id " +
                 "JOIN members m ON i.member_id = m.id " +
                 "ORDER BY i.date_issued DESC " +
                 "LIMIT ?";
    
    try (Connection conn = DBConnection.getConnection();
         PreparedStatement stmt = conn.prepareStatement(sql)) {
        
        stmt.setInt(1, limit);
        
        try (ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                IssuedBook issuedBook = new IssuedBook();
                issuedBook.setId(rs.getInt("id"));
                issuedBook.setBookId(rs.getInt("book_id"));
                issuedBook.setMemberId(rs.getInt("member_id"));
                issuedBook.setDateIssued(rs.getTimestamp("date_issued"));
                issuedBook.setDueDate(rs.getTimestamp("due_date"));
                issuedBook.setDateReturned(rs.getTimestamp("date_returned"));
                issuedBook.setReturnStatus(rs.getString("return_status"));
                issuedBook.setExtensionStatus(rs.getString("extension_status"));
                issuedBook.setBookTitle(rs.getString("book_title"));
                issuedBook.setMemberName(rs.getString("member_name"));
                recentBooks.add(issuedBook);
            }
        }
    } catch (SQLException | ClassNotFoundException e) {
        e.printStackTrace();
    }
    
    return recentBooks;
}
/**
 * Get book borrowing history for a specific member
 * @param bookId Book ID
 * @param memberId Member ID
 * @return List of issued books for this book by this member
 */
public List<IssuedBook> getMemberBookHistory(int bookId, int memberId) {
    List<IssuedBook> borrowHistory = new ArrayList<>();
    String sql = "SELECT i.*, b.title as book_title " +
                 "FROM issued_books i " +
                 "JOIN books b ON i.book_id = b.id " +
                 "WHERE i.book_id = ? AND i.member_id = ? " +
                 "ORDER BY i.date_issued DESC";
    
    try (Connection conn = DBConnection.getConnection();
         PreparedStatement stmt = conn.prepareStatement(sql)) {
        
        stmt.setInt(1, bookId);
        stmt.setInt(2, memberId);
        
        try (ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                IssuedBook issuedBook = new IssuedBook();
                issuedBook.setId(rs.getInt("id"));
                issuedBook.setBookId(rs.getInt("book_id"));
                issuedBook.setMemberId(rs.getInt("member_id"));
                issuedBook.setDateIssued(rs.getTimestamp("date_issued"));
                issuedBook.setDueDate(rs.getTimestamp("due_date"));
                issuedBook.setDateReturned(rs.getTimestamp("date_returned"));
                issuedBook.setReturnStatus(rs.getString("return_status"));
                issuedBook.setExtensionStatus(rs.getString("extension_status"));
                issuedBook.setBookTitle(rs.getString("book_title"));
                borrowHistory.add(issuedBook);
            }
        }
    } catch (SQLException | ClassNotFoundException e) {
        e.printStackTrace();
    }
    
    return borrowHistory;
}
/**
 * Get not returned books
 * @return List of not returned books
 */

/**
 * Get all issued books for a specific member (both returned and not returned)
 * @param memberId Member ID
 * @return List of all issued books for the member
 */
public List<IssuedBook> getAllIssuedBooksByMember(int memberId) {
    List<IssuedBook> result = new ArrayList<>();
    String sql = "SELECT ib.*, b.title AS book_title FROM issued_books ib " +
                 "JOIN books b ON ib.book_id = b.id " +
                 "WHERE ib.member_id = ? " +
                 "ORDER BY ib.date_issued DESC";
    
    try (Connection conn = DBConnection.getConnection();
         PreparedStatement stmt = conn.prepareStatement(sql)) {
        
        stmt.setInt(1, memberId);
        ResultSet rs = stmt.executeQuery();
        
        while (rs.next()) {
            IssuedBook book = new IssuedBook();
            book.setId(rs.getInt("id"));
            book.setBookId(rs.getInt("book_id"));
            book.setMemberId(rs.getInt("member_id"));
            book.setDateIssued(rs.getTimestamp("date_issued"));
            book.setDueDate(rs.getTimestamp("due_date"));
            book.setDateReturned(rs.getTimestamp("date_returned"));
            book.setReturnStatus(rs.getString("return_status"));
            book.setExtensionStatus(rs.getString("extension_status"));
            book.setBookTitle(rs.getString("book_title"));
            
            result.add(book);
        }
        
    } catch (SQLException | ClassNotFoundException e) {
        e.printStackTrace();
    }
    
    return result;
}

public List<IssuedBook> getNotReturnedBooks() {
    List<IssuedBook> notReturnedBooks = new ArrayList<>();
    String sql = "SELECT i.*, b.title as book_title, m.name as member_name " +
                 "FROM issued_books i " +
                 "JOIN books b ON i.book_id = b.id " +
                 "JOIN members m ON i.member_id = m.id " +
                 "WHERE i.return_status = 'NOT_RETURNED' " +
                 "ORDER BY i.date_issued DESC";
    
    try (Connection conn = DBConnection.getConnection();
         Statement stmt = conn.createStatement();
         ResultSet rs = stmt.executeQuery(sql)) {
        
        while (rs.next()) {
            IssuedBook issuedBook = new IssuedBook();
            issuedBook.setId(rs.getInt("id"));
            issuedBook.setBookId(rs.getInt("book_id"));
            issuedBook.setMemberId(rs.getInt("member_id"));
            issuedBook.setDateIssued(rs.getTimestamp("date_issued"));
            issuedBook.setDueDate(rs.getTimestamp("due_date"));
            issuedBook.setDateReturned(rs.getTimestamp("date_returned"));
            issuedBook.setReturnStatus(rs.getString("return_status"));
            issuedBook.setExtensionStatus(rs.getString("extension_status"));
            issuedBook.setBookTitle(rs.getString("book_title"));
            issuedBook.setMemberName(rs.getString("member_name"));
            notReturnedBooks.add(issuedBook);
        }
    } catch (SQLException | ClassNotFoundException e) {
        e.printStackTrace();
    }
    
    return notReturnedBooks;
}

    
public List<IssuedBook> getNotReturnedBooksByBookTitle(String bookTitle) {
    List<IssuedBook> notReturnedBooks = new ArrayList<>();
    String sql = "SELECT i.*, b.title as book_title, m.name as member_name " +
                 "FROM issued_books i " +
                 "JOIN books b ON i.book_id = b.id " +
                 "JOIN members m ON i.member_id = m.id " +
                 "WHERE i.return_status = 'NOT_RETURNED' AND b.title LIKE ? " +
                 "ORDER BY i.date_issued DESC";

    try (Connection conn = DBConnection.getConnection();
         PreparedStatement stmt = conn.prepareStatement(sql)) {

        stmt.setString(1, "%" + bookTitle + "%");

        try (ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                IssuedBook issuedBook = new IssuedBook();
                issuedBook.setId(rs.getInt("id"));
                issuedBook.setBookId(rs.getInt("book_id"));
                issuedBook.setMemberId(rs.getInt("member_id"));
                issuedBook.setDateIssued(rs.getTimestamp("date_issued"));
                issuedBook.setDueDate(rs.getTimestamp("due_date"));
                issuedBook.setDateReturned(rs.getTimestamp("date_returned"));
                issuedBook.setReturnStatus(rs.getString("return_status"));
                issuedBook.setExtensionStatus(rs.getString("extension_status"));
                issuedBook.setBookTitle(rs.getString("book_title"));
                issuedBook.setMemberName(rs.getString("member_name"));
                notReturnedBooks.add(issuedBook);
            }
        }
    } catch (SQLException | ClassNotFoundException e) {
        e.printStackTrace();
    }

    return notReturnedBooks;
}

public List<IssuedBook> getNotReturnedBooksByMemberName(String memberName) {
    List<IssuedBook> notReturnedBooks = new ArrayList<>();
    String sql = "SELECT i.*, b.title as book_title, m.name as member_name " +
                 "FROM issued_books i " +
                 "JOIN books b ON i.book_id = b.id " +
                 "JOIN members m ON i.member_id = m.id " +
                 "WHERE i.return_status = 'NOT_RETURNED' AND m.name LIKE ? " +
                 "ORDER BY i.date_issued DESC";

    try (Connection conn = DBConnection.getConnection();
         PreparedStatement stmt = conn.prepareStatement(sql)) {

        stmt.setString(1, "%" + memberName + "%");

        try (ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                IssuedBook issuedBook = new IssuedBook();
                issuedBook.setId(rs.getInt("id"));
                issuedBook.setBookId(rs.getInt("book_id"));
                issuedBook.setMemberId(rs.getInt("member_id"));
                issuedBook.setDateIssued(rs.getTimestamp("date_issued"));
                issuedBook.setDueDate(rs.getTimestamp("due_date"));
                issuedBook.setDateReturned(rs.getTimestamp("date_returned"));
                issuedBook.setReturnStatus(rs.getString("return_status"));
                issuedBook.setExtensionStatus(rs.getString("extension_status"));
                issuedBook.setBookTitle(rs.getString("book_title"));
                issuedBook.setMemberName(rs.getString("member_name"));
                notReturnedBooks.add(issuedBook);
            }
        }
    } catch (SQLException | ClassNotFoundException e) {
        e.printStackTrace();
    }

    return notReturnedBooks;
}

public List<IssuedBook> getNotReturnedBooksByMemberId(int memberId) {
    List<IssuedBook> notReturnedBooks = new ArrayList<>();
    String sql = "SELECT i.*, b.title as book_title, m.name as member_name " +
                 "FROM issued_books i " +
                 "JOIN books b ON i.book_id = b.id " +
                 "JOIN members m ON i.member_id = m.id " +
                 "WHERE i.return_status = 'NOT_RETURNED' AND i.member_id = ? " +
                 "ORDER BY i.date_issued DESC";
    
    try (Connection conn = DBConnection.getConnection();
         PreparedStatement stmt = conn.prepareStatement(sql)) {
        
        stmt.setInt(1, memberId);
        
        try (ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                IssuedBook issuedBook = new IssuedBook();
                issuedBook.setId(rs.getInt("id"));
                issuedBook.setBookId(rs.getInt("book_id"));
                issuedBook.setMemberId(rs.getInt("member_id"));
                issuedBook.setDateIssued(rs.getTimestamp("date_issued"));
                issuedBook.setDueDate(rs.getTimestamp("due_date"));
                issuedBook.setDateReturned(rs.getTimestamp("date_returned"));
                issuedBook.setReturnStatus(rs.getString("return_status"));
                issuedBook.setExtensionStatus(rs.getString("extension_status"));
                issuedBook.setBookTitle(rs.getString("book_title"));
                issuedBook.setMemberName(rs.getString("member_name"));
                notReturnedBooks.add(issuedBook);
            }
        }
    } catch (SQLException | ClassNotFoundException e) {
        e.printStackTrace();
    }
    
    return notReturnedBooks;
}

public boolean returnBook(int issuedBookId) {
    try (Connection conn = DBConnection.getConnection()) {
        // Start transaction
        conn.setAutoCommit(false);
        
        try {
            // 1. Get the book ID and check if the issued book exists
            int bookId = 0;
            PreparedStatement getStmt = conn.prepareStatement(
                "SELECT book_id, return_status FROM issued_books WHERE id = ?");
            getStmt.setInt(1, issuedBookId);
            ResultSet rs = getStmt.executeQuery();
            
            if (!rs.next()) {
                System.out.println("Issued book not found with ID: " + issuedBookId);
                conn.rollback();
                return false;
            }
            
            bookId = rs.getInt("book_id");
            String returnStatus = rs.getString("return_status");
            
            // Check if book is already returned
            if ("RETURNED".equals(returnStatus)) {
                System.out.println("Book is already returned");
                conn.rollback();
                return false;
            }
            
            // 2. Update issued_books table
            PreparedStatement updateStmt = conn.prepareStatement(
                "UPDATE issued_books SET date_returned = CURRENT_TIMESTAMP, return_status = 'RETURNED' WHERE id = ?");
            updateStmt.setInt(1, issuedBookId);
            int updateRows = updateStmt.executeUpdate();
            
            if (updateRows <= 0) {
                System.out.println("Failed to update return status");
                conn.rollback();
                return false;
            }
            
            // 3. Update book availability
            PreparedStatement bookStmt = conn.prepareStatement(
                "UPDATE books SET available_copies = available_copies + 1, " +
                "status = CASE WHEN available_copies + 1 > 0 THEN 'AVAILABLE' ELSE status END " +
                "WHERE id = ?");
            bookStmt.setInt(1, bookId);
            int bookRows = bookStmt.executeUpdate();
            
            if (bookRows <= 0) {
                System.out.println("Failed to update book availability");
                conn.rollback();
                return false;
            }
            
            // Commit the transaction
            conn.commit();
            System.out.println("Book return successful. ID: " + issuedBookId + ", Book ID: " + bookId);
            return true;
            
        } catch (SQLException e) {
            conn.rollback();
            System.out.println("SQL Exception during return: " + e.getMessage());
            e.printStackTrace();
            return false;
        } finally {
            conn.setAutoCommit(true);
        }
    } catch (SQLException | ClassNotFoundException e) {
        System.out.println("Database connection error: " + e.getMessage());
        e.printStackTrace();
        return false;
    }
}
    
    /**
     * Request extension for a book
     * @param issuedBookId Issued book ID
     * @return true if successful, false otherwise
     */
    public boolean requestExtension(int issuedBookId) {
        String sql = "UPDATE issued_books SET extension_status = 'REQUESTED' WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, issuedBookId);
            
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            return false;
        }
    }
    

    /**
 * Approve or reject extension request
 * @param issuedBookId Issued book ID
 * @param approved true to approve, false to reject
 * @param newDueDate New due date if approved
 * @return true if successful, false otherwise
 */
public boolean processExtensionRequest(int issuedBookId, boolean approved, Timestamp newDueDate) {
    try (Connection conn = DBConnection.getConnection()) {
        // Start transaction
        conn.setAutoCommit(false);
        
        try {
            // First check if the book has already been returned
            String checkSql = "SELECT return_status FROM issued_books WHERE id = ?";
            try (PreparedStatement checkStmt = conn.prepareStatement(checkSql)) {
                checkStmt.setInt(1, issuedBookId);
                ResultSet rs = checkStmt.executeQuery();
                
                if (!rs.next()) {
                    System.out.println("Issued book not found: " + issuedBookId);
                    conn.rollback();
                    return false;
                }
                
                String returnStatus = rs.getString("return_status");
                if ("RETURNED".equals(returnStatus)) {
                    System.out.println("Cannot process extension for returned book: " + issuedBookId);
                    conn.rollback();
                    return false;
                }
            }
            
            // Prepare SQL based on approval status
            String status = approved ? "APPROVED" : "REJECTED";
            String sql;
            
            if (approved) {
                sql = "UPDATE issued_books SET extension_status = ?, due_date = ? WHERE id = ?";
            } else {
                sql = "UPDATE issued_books SET extension_status = ? WHERE id = ?";
            }
            
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setString(1, status);
                
                if (approved) {
                    stmt.setTimestamp(2, newDueDate);
                    stmt.setInt(3, issuedBookId);
                } else {
                    stmt.setInt(2, issuedBookId);
                }
                
                int rowsAffected = stmt.executeUpdate();
                
                if (rowsAffected > 0) {
                    conn.commit();
                    System.out.println("Extension request " + status.toLowerCase() + " for issued book ID: " + issuedBookId);
                    return true;
                } else {
                    conn.rollback();
                    System.out.println("Failed to process extension request");
                    return false;
                }
            }
        } catch (SQLException e) {
            conn.rollback();
            System.out.println("SQL Exception during extension processing: " + e.getMessage());
            e.printStackTrace();
            return false;
        } finally {
            conn.setAutoCommit(true);
        }
    } catch (SQLException | ClassNotFoundException e) {
        System.out.println("Database connection error: " + e.getMessage());
        e.printStackTrace();
        return false;
    }
}
    /**
     * Get all issued books (with book and member details)
     * @return List of issued books
     */
    public List<IssuedBook> getAllIssuedBooks() {
        List<IssuedBook> issuedBooks = new ArrayList<>();
        String sql = "SELECT i.*, b.title as book_title, m.name as member_name " +
                     "FROM issued_books i " +
                     "JOIN books b ON i.book_id = b.id " +
                     "JOIN members m ON i.member_id = m.id " +
                     "ORDER BY i.date_issued DESC";
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                IssuedBook issuedBook = new IssuedBook();
                issuedBook.setId(rs.getInt("id"));
                issuedBook.setBookId(rs.getInt("book_id"));
                issuedBook.setMemberId(rs.getInt("member_id"));
                issuedBook.setDateIssued(rs.getTimestamp("date_issued"));
                issuedBook.setDueDate(rs.getTimestamp("due_date"));
                issuedBook.setDateReturned(rs.getTimestamp("date_returned"));
                issuedBook.setReturnStatus(rs.getString("return_status"));
                issuedBook.setExtensionStatus(rs.getString("extension_status"));
                issuedBook.setBookTitle(rs.getString("book_title"));
                issuedBook.setMemberName(rs.getString("member_name"));
                issuedBooks.add(issuedBook);
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        
        return issuedBooks;
    }
    
    /**
     * Get books issued to a specific member
     * @param memberId Member ID
     * @return List of issued books for the member
     */
    public List<IssuedBook> getIssuedBooksByMember(int memberId) {
        List<IssuedBook> issuedBooks = new ArrayList<>();
        String sql = "SELECT i.*, b.title as book_title " +
                     "FROM issued_books i " +
                     "JOIN books b ON i.book_id = b.id " +
                     "WHERE i.member_id = ? " +
                     "ORDER BY i.date_issued DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, memberId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    IssuedBook issuedBook = new IssuedBook();
                    issuedBook.setId(rs.getInt("id"));
                    issuedBook.setBookId(rs.getInt("book_id"));
                    issuedBook.setMemberId(rs.getInt("member_id"));
                    issuedBook.setDateIssued(rs.getTimestamp("date_issued"));
                    issuedBook.setDueDate(rs.getTimestamp("due_date"));
                    issuedBook.setDateReturned(rs.getTimestamp("date_returned"));
                    issuedBook.setReturnStatus(rs.getString("return_status"));
                    issuedBook.setExtensionStatus(rs.getString("extension_status"));
                    issuedBook.setBookTitle(rs.getString("book_title"));
                    issuedBooks.add(issuedBook);
                }
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        
        return issuedBooks;
    }
    
    /**
     * Get returned books for a specific member
     * @param memberId Member ID
     * @return List of returned books for the member
     */
    public List<IssuedBook> getReturnedBooksByMember(int memberId) {
        List<IssuedBook> returnedBooks = new ArrayList<>();
        String sql = "SELECT i.*, b.title as book_title " +
                     "FROM issued_books i " +
                     "JOIN books b ON i.book_id = b.id " +
                     "WHERE i.member_id = ? AND i.return_status = 'RETURNED' " +
                     "ORDER BY i.date_returned DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, memberId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    IssuedBook issuedBook = new IssuedBook();
                    issuedBook.setId(rs.getInt("id"));
                    issuedBook.setBookId(rs.getInt("book_id"));
                    issuedBook.setMemberId(rs.getInt("member_id"));
                    issuedBook.setDateIssued(rs.getTimestamp("date_issued"));
                    issuedBook.setDueDate(rs.getTimestamp("due_date"));
                    issuedBook.setDateReturned(rs.getTimestamp("date_returned"));
                    issuedBook.setReturnStatus(rs.getString("return_status"));
                    issuedBook.setExtensionStatus(rs.getString("extension_status"));
                    issuedBook.setBookTitle(rs.getString("book_title"));
                    returnedBooks.add(issuedBook);
                }
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        
        return returnedBooks;
    }
    
    /**
     * Get overdue books (not returned and past due date)
     * @return List of overdue books
     */
    public List<IssuedBook> getOverdueBooks() {
        List<IssuedBook> overdueBooks = new ArrayList<>();
        String sql = "SELECT i.*, b.title as book_title, m.name as member_name " +
                     "FROM issued_books i " +
                     "JOIN books b ON i.book_id = b.id " +
                     "JOIN members m ON i.member_id = m.id " +
                     "WHERE i.return_status = 'NOT_RETURNED' AND i.due_date < CURRENT_TIMESTAMP " +
                     "ORDER BY i.due_date ASC";
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                IssuedBook issuedBook = new IssuedBook();
                issuedBook.setId(rs.getInt("id"));
                issuedBook.setBookId(rs.getInt("book_id"));
                issuedBook.setMemberId(rs.getInt("member_id"));
                issuedBook.setDateIssued(rs.getTimestamp("date_issued"));
                issuedBook.setDueDate(rs.getTimestamp("due_date"));
                issuedBook.setDateReturned(rs.getTimestamp("date_returned"));
                issuedBook.setReturnStatus(rs.getString("return_status"));
                issuedBook.setExtensionStatus(rs.getString("extension_status"));
                issuedBook.setBookTitle(rs.getString("book_title"));
                issuedBook.setMemberName(rs.getString("member_name"));
                overdueBooks.add(issuedBook);
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        
        return overdueBooks;
    }
    
    /**
     * Check if a book is already issued to a member and not returned
     * @param bookId Book ID
     * @param memberId Member ID
     * @return true if book is already issued, false otherwise
     */
    /**
 * Get issued book by ID
 * @param id Issued book ID
 * @return IssuedBook object or null if not found
 */
public IssuedBook getIssuedBookById(int id) {
    String sql = "SELECT i.*, b.title as book_title, m.name as member_name " +
                 "FROM issued_books i " +
                 "JOIN books b ON i.book_id = b.id " +
                 "JOIN members m ON i.member_id = m.id " +
                 "WHERE i.id = ?";
    
    try (Connection conn = DBConnection.getConnection();
         PreparedStatement stmt = conn.prepareStatement(sql)) {
        
        stmt.setInt(1, id);
        
        try (ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                IssuedBook issuedBook = new IssuedBook();
                issuedBook.setId(rs.getInt("id"));
                issuedBook.setBookId(rs.getInt("book_id"));
                issuedBook.setMemberId(rs.getInt("member_id"));
                issuedBook.setDateIssued(rs.getTimestamp("date_issued"));
                issuedBook.setDueDate(rs.getTimestamp("due_date"));
                issuedBook.setDateReturned(rs.getTimestamp("date_returned"));
                issuedBook.setReturnStatus(rs.getString("return_status"));
                issuedBook.setExtensionStatus(rs.getString("extension_status"));
                issuedBook.setBookTitle(rs.getString("book_title"));
                issuedBook.setMemberName(rs.getString("member_name"));
                return issuedBook;
            }
        }
    } catch (SQLException | ClassNotFoundException e) {
        e.printStackTrace();
    }
    
    return null;
}
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
    
    /**
     * Get count of currently borrowed books
     * @return Number of borrowed books
     */
    public int getCurrentlyBorrowedBooksCount() {
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
