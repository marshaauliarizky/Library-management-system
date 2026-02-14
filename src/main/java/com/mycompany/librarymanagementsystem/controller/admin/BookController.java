package com.mycompany.librarymanagementsystem.controller.admin;

import com.mycompany.librarymanagementsystem.dao.BookDAO;
import com.mycompany.librarymanagementsystem.model.Admin;
import com.mycompany.librarymanagementsystem.model.Book;
import com.mycompany.librarymanagementsystem.util.SessionUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import org.json.JSONObject; 

@WebServlet("/admin/books")
public class BookController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private BookDAO bookDAO;
    
    @Override
    public void init() throws ServletException {
        bookDAO = new BookDAO();
    }
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Check if admin is logged in
        Admin admin = SessionUtil.getAdminFromSession(request);
        if (admin == null) {
            response.sendRedirect(request.getContextPath() + "/admin-login");
            return;
        }
        
        String action = request.getParameter("action");
        
        if (action == null) {
            listBooks(request, response);
        } else {
            switch (action) {
                case "add":
                    showAddForm(request, response);
                    break;
                case "edit":
                    showEditForm(request, response);
                    break;
                case "delete":
                    deleteBook(request, response);
                    break;
                case "getDetails":
                    getBookDetails(request, response);
                    break;
                default:
                    listBooks(request, response);
            }
        }
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Check if admin is logged in
        Admin admin = SessionUtil.getAdminFromSession(request);
        if (admin == null) {
            response.sendRedirect(request.getContextPath() + "/admin-login");
            return;
        }
        
        String action = request.getParameter("action");
        
        if (action == null || action.equals("save")) {
            saveBook(request, response);
        } else {
            doGet(request, response);
        }
    }
    

    private void listBooks(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Book> books = bookDAO.getAllBooks();
        request.setAttribute("books", books);
        
        request.getRequestDispatcher("/admin/books/list.jsp").forward(request, response);
    }
    

    private void showAddForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/admin/books/add.jsp").forward(request, response);
    }
    

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String bookId = request.getParameter("id");
        
        if (bookId == null || bookId.isEmpty()) {
            request.setAttribute("errorMessage", "Book ID is required");
            listBooks(request, response);
            return;
        }
        
        try {
            int id = Integer.parseInt(bookId);
            
            Book book = bookDAO.getBookById(id);
            
            if (book == null) {
                request.setAttribute("errorMessage", "Book not found");
                listBooks(request, response);
                return;
            }
            
            request.setAttribute("book", book);
            
            request.getRequestDispatcher("/admin/books/edit.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid book ID");
            listBooks(request, response);
        }
    }

private void saveBook(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

    String bookId = request.getParameter("id");
    String title = request.getParameter("title");
    String synopsis = request.getParameter("synopsis");
    String author = request.getParameter("author");
    String isbn = request.getParameter("isbn");
    String publisher = request.getParameter("publisher");
    String publicationYearStr = request.getParameter("publicationYear");
    String totalCopiesStr = request.getParameter("totalCopies");
    String availableCopiesStr = request.getParameter("availableCopies");
    
    if (title == null || title.isEmpty() ||
        synopsis == null || synopsis.isEmpty() ||
        author == null || author.isEmpty() ||
        isbn == null || isbn.isEmpty() ||
        totalCopiesStr == null || totalCopiesStr.isEmpty()) {
        
        request.setAttribute("errorMessage", "Title, synopsis, author, ISBN, and total copies are required");
        
        if (bookId == null || bookId.isEmpty()) {
            request.getRequestDispatcher("/admin/books/add.jsp").forward(request, response);
        } else {
            request.setAttribute("id", bookId);
            request.getRequestDispatcher("/admin/books?action=edit&id=" + bookId).forward(request, response);
        }
        return;
    }
    
    try {
        Book book = new Book();
        book.setTitle(title);
        book.setSynopsis(synopsis);
        book.setAuthor(author);
        book.setIsbn(isbn);
        book.setPublisher(publisher);
        
        int totalCopies = Integer.parseInt(totalCopiesStr);
        book.setTotalCopies(totalCopies);
        
        if (publicationYearStr != null && !publicationYearStr.isEmpty()) {
            int publicationYear = Integer.parseInt(publicationYearStr);
            book.setPublicationYear(publicationYear);
        }
        
        boolean success;
        
        if (bookId == null || bookId.isEmpty()) {
            // Add new book - all copies are available when first added
            book.setAvailableCopies(totalCopies);
            
            // Set status based on availability
            if (totalCopies > 0) {
                book.setStatus("AVAILABLE");
            } else {
                book.setStatus("BORROWED");
            }
            
            success = bookDAO.addBook(book);
            
            if (success) {
                request.setAttribute("successMessage", "Book added successfully");
                request.setAttribute("newBookId", bookDAO.getLastInsertedId());
            } else {
                request.setAttribute("errorMessage", "Failed to add book");
            }
        } else {
            int id = Integer.parseInt(bookId);
            book.setId(id);
            
            Book existingBook = bookDAO.getBookById(id);
            
            if (existingBook == null) {
                request.setAttribute("errorMessage", "Book not found");
                listBooks(request, response);
                return;
            }
            
            int availableCopies;
            if (availableCopiesStr != null && !availableCopiesStr.isEmpty()) {
                availableCopies = Integer.parseInt(availableCopiesStr);
                
                // Validate available copies
                if (availableCopies > totalCopies) {
                    request.setAttribute("errorMessage", "Available copies cannot be greater than total copies");
                    request.setAttribute("book", book);
                    request.getRequestDispatcher("/admin/books/edit.jsp").forward(request, response);
                    return;
                }
                
                book.setAvailableCopies(availableCopies);
            } else {
                // If total copies changed but available not specified, adjust proportionally
                int oldTotal = existingBook.getTotalCopies();
                int oldAvailable = existingBook.getAvailableCopies();
                
                // If total increased, add the difference to available
                if (totalCopies > oldTotal) {
                    availableCopies = oldAvailable + (totalCopies - oldTotal);
                } else if (totalCopies < oldTotal) {
                    // If total decreased, reduce available proportionally but not below 0
                    int borrowed = oldTotal - oldAvailable;
                    availableCopies = Math.max(0, totalCopies - borrowed);
                } else {
                    // If total unchanged, keep available the same
                    availableCopies = oldAvailable;
                }
                
                book.setAvailableCopies(availableCopies);
            }
            
            // Set status based on available copies
            if (book.getAvailableCopies() > 0) {
                book.setStatus("AVAILABLE");
            } else {
                book.setStatus("BORROWED");
            }
            
            success = bookDAO.updateBook(book);
            
            if (success) {
                request.setAttribute("successMessage", "Book updated successfully");
                // Set updated book ID for highlighting
                request.setAttribute("newBookId", id);
            } else {
                request.setAttribute("errorMessage", "Failed to update book");
            }
        }
        
        // Redirect to books list
        listBooks(request, response);
        
    } catch (NumberFormatException e) {
        request.setAttribute("errorMessage", "Invalid number format");
        
        if (bookId == null || bookId.isEmpty()) {
            request.getRequestDispatcher("/admin/books/add.jsp").forward(request, response);
        } else {
            request.setAttribute("id", bookId);
            request.getRequestDispatcher("/admin/books?action=edit&id=" + bookId).forward(request, response);
        }
    }
}
   
    private void deleteBook(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Get book ID
        String bookId = request.getParameter("id");
        
        if (bookId == null || bookId.isEmpty()) {
            request.setAttribute("errorMessage", "Book ID is required");
            listBooks(request, response);
            return;
        }
        
        try {
            int id = Integer.parseInt(bookId);
            
            boolean success = bookDAO.deleteBook(id);
            
            if (success) {
                request.setAttribute("successMessage", "Book deleted successfully");
            } else {
                request.setAttribute("errorMessage", "Failed to delete book");
            }
            
            // Redirect to books list
            listBooks(request, response);
            
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid book ID");
            listBooks(request, response);
        }
    }
    
  
private void getBookDetails(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
    // Get book ID
    String bookId = request.getParameter("id");
    
    if (bookId == null || bookId.isEmpty()) {
        response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
        response.getWriter().write("Book ID is required");
        return;
    }
    
    try {
        int id = Integer.parseInt(bookId);
        
        // Get book
        Book book = bookDAO.getBookById(id);
        
        if (book == null) {
            response.setStatus(HttpServletResponse.SC_NOT_FOUND);
            response.getWriter().write("Book not found");
            return;
        }
        
        // Create JSON response
        JSONObject json = new JSONObject();
        json.put("id", book.getId());
        json.put("title", book.getTitle());
        json.put("synopsis", book.getSynopsis() != null ? book.getSynopsis() : "");
        json.put("author", book.getAuthor());
        json.put("isbn", book.getIsbn());
        json.put("publisher", book.getPublisher() != null ? book.getPublisher() : "");
        json.put("publicationYear", book.getPublicationYear() > 0 ? book.getPublicationYear() : "");
        json.put("totalCopies", book.getTotalCopies());
        json.put("availableCopies", book.getAvailableCopies());
        json.put("status", book.getStatus());
        
        // Send JSON response
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write(json.toString());
        
    } catch (NumberFormatException e) {
        response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
        response.getWriter().write("Invalid book ID");
    }
}
}