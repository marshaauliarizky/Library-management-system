package com.mycompany.librarymanagementsystem.controller.admin;

import com.mycompany.librarymanagementsystem.dao.BookDAO;
import com.mycompany.librarymanagementsystem.dao.IssuedBookDAO;
import com.mycompany.librarymanagementsystem.dao.MemberDAO;
import com.mycompany.librarymanagementsystem.model.Admin;
import com.mycompany.librarymanagementsystem.model.Book;
import com.mycompany.librarymanagementsystem.model.IssuedBook;
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
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.List;

@WebServlet("/admin/issued-books")
public class IssuedBookController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private IssuedBookDAO issuedBookDAO;
    private BookDAO bookDAO;
    private MemberDAO memberDAO;
    
    @Override
    public void init() throws ServletException {
        issuedBookDAO = new IssuedBookDAO();
        bookDAO = new BookDAO();
        memberDAO = new MemberDAO();
    }
    
   protected void doGet(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
    // Check if admin is logged in
    Admin admin = SessionUtil.getAdminFromSession(request);
    if (admin == null) {
        response.sendRedirect(request.getContextPath() + "/admin-login");
        return;
    }
    
    // Get action parameter
    String action = request.getParameter("action");
    String filter = request.getParameter("filter");
    
    request.setAttribute("now", new Timestamp(System.currentTimeMillis()));
    
    if (action != null) {
        switch (action) {
            case "issue":
                showIssueForm(request, response);
                return;
            case "extension":
                processExtension(request, response);
                return;
            case "overdue":
                listOverdueBooks(request, response);
                return;
        }
    }
    
    // Filter handling
    if (filter != null) {
        switch (filter) {
            case "not-returned":
                listNotReturnedBooks(request, response);
                return;
            case "returned":
                listReturnedBooks(request, response);
                return;
            case "extension-requests":
                listExtensionRequests(request, response);
                return;
        }
    }
    
    // Default action: list all issued books
    listIssuedBooks(request, response);
}

// Metode untuk filter "not-returned"
private void listNotReturnedBooks(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
    List<IssuedBook> notReturnedBooks = issuedBookDAO.getNotReturnedBooks();
    request.setAttribute("issuedBooks", notReturnedBooks);
    request.setAttribute("filterActive", "not-returned");
    request.getRequestDispatcher("/admin/issued-books/list.jsp").forward(request, response);
}

// Metode untuk filter "returned"
private void listReturnedBooks(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
    List<IssuedBook> returnedBooks = issuedBookDAO.getReturnedBooks();
    request.setAttribute("issuedBooks", returnedBooks);
    request.setAttribute("filterActive", "returned");
    request.getRequestDispatcher("/admin/issued-books/list.jsp").forward(request, response);
}

// Metode untuk filter "extension-requests"
private void listExtensionRequests(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
    List<IssuedBook> extensionRequests = issuedBookDAO.getExtensionRequests();
    request.setAttribute("issuedBooks", extensionRequests);
    request.setAttribute("filterActive", "extension-requests");
    request.getRequestDispatcher("/admin/issued-books/list.jsp").forward(request, response);
}
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Check if admin is logged in
        Admin admin = SessionUtil.getAdminFromSession(request);
        if (admin == null) {
            response.sendRedirect(request.getContextPath() + "/admin-login");
            return;
        }
        
        // Get action parameter
        String action = request.getParameter("action");
        
        if (action == null) {
            // Default action: list all issued books
            listIssuedBooks(request, response);
        } else {
            switch (action) {
                case "issue":
                    issueBook(request, response);
                    break;
                default:
                    listIssuedBooks(request, response);
            }
        }
    }
    
    private void listIssuedBooks(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Get all issued books
        List<IssuedBook> issuedBooks = issuedBookDAO.getAllIssuedBooks();
        
        // Set attributes
        request.setAttribute("issuedBooks", issuedBooks);
        request.setAttribute("now", new Timestamp(System.currentTimeMillis()));
        
        // Forward to issued books list page
        request.getRequestDispatcher("/admin/issued-books/list.jsp").forward(request, response);
    }
    
    private void showIssueForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Get books and members for dropdowns
        List<Book> availableBooks = bookDAO.getAvailableBooks();
        List<Member> activeMembers = memberDAO.getActiveMembers();
        
        // Set attributes
        request.setAttribute("books", availableBooks);
        request.setAttribute("members", activeMembers);
        
        // Set default due date (14 days from now)
        request.setAttribute("defaultDueDate", DateUtil.formatDate(DateUtil.calculateDueDate()));
        
        // Forward to issue book form
        request.getRequestDispatcher("/admin/issued-books/issue.jsp").forward(request, response);
    }
    
    private void issueBook(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
    // Get form data
    String bookId = request.getParameter("bookId");
    String memberId = request.getParameter("memberId");
    String dueDateStr = request.getParameter("dueDate");
    
    System.out.println("====== ISSUE BOOK DEBUG ======");
    System.out.println("Book ID: " + bookId);
    System.out.println("Member ID: " + memberId);
    System.out.println("Due Date: " + dueDateStr);
    
    // Validate input
    if (bookId == null || bookId.isEmpty() ||
        memberId == null || memberId.isEmpty() ||
        dueDateStr == null || dueDateStr.isEmpty()) {
        
        System.out.println("ERROR: Missing required fields");
        request.setAttribute("errorMessage", "Book, member, and due date are required");
        showIssueForm(request, response);
        return;
    }
    
    try {
        int bookIdInt = Integer.parseInt(bookId);
        int memberIdInt = Integer.parseInt(memberId);
        
        // Parse date correctly
        java.util.Date parsedDate = null;
        try {
            // Try different date formats
            if (dueDateStr.matches("\\d{4}-\\d{2}-\\d{2}")) {
                // yyyy-MM-dd format
                SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
                parsedDate = dateFormat.parse(dueDateStr);
            } else {
                // Other formats (add more if needed)
                SimpleDateFormat altFormat = new SimpleDateFormat("MM/dd/yyyy");
                parsedDate = altFormat.parse(dueDateStr);
            }
        } catch (ParseException pe) {
            System.out.println("ERROR: Date parsing failed - " + pe.getMessage());
            throw pe;
        }
        
        Timestamp dueDate = new Timestamp(parsedDate.getTime());
        System.out.println("Parsed Due Date: " + dueDate);
        
        // Check if book exists and is available
        Book book = bookDAO.getBookById(bookIdInt);
        if (book == null) {
            System.out.println("ERROR: Book not found with ID: " + bookIdInt);
            request.setAttribute("errorMessage", "Book not found");
            showIssueForm(request, response);
            return;
        }
        
        System.out.println("Book status: " + book.getStatus() + ", Available copies: " + book.getAvailableCopies());
        
        if (!"AVAILABLE".equals(book.getStatus()) || book.getAvailableCopies() <= 0) {
            System.out.println("ERROR: Book not available for borrowing");
            request.setAttribute("errorMessage", "Book is not available for borrowing");
            showIssueForm(request, response);
            return;
        }
        
        // Check if member exists and is active
        Member member = memberDAO.getMemberById(memberIdInt);
        if (member == null) {
            System.out.println("ERROR: Member not found with ID: " + memberIdInt);
            request.setAttribute("errorMessage", "Member not found");
            showIssueForm(request, response);
            return;
        }
        
        System.out.println("Member status: " + member.getStatus());
        
        if (!"ACTIVE".equals(member.getStatus())) {
            System.out.println("ERROR: Member is not active");
            request.setAttribute("errorMessage", "Member is not active");
            showIssueForm(request, response);
            return;
        }
        
        // Check if book is already issued to member
        boolean alreadyIssued = issuedBookDAO.isBookIssuedToMember(bookIdInt, memberIdInt);
        System.out.println("Book already issued to member? " + alreadyIssued);
        
        if (alreadyIssued) {
            request.setAttribute("errorMessage", "This book is already issued to this member");
            showIssueForm(request, response);
            return;
        }
        
        // Issue book
        System.out.println("Attempting to issue book...");
        boolean success = issuedBookDAO.issueBook(bookIdInt, memberIdInt, dueDate);
        
        if (success) {
            System.out.println("Book issued successfully!");
            request.setAttribute("successMessage", "Book issued successfully");
            listIssuedBooks(request, response);
        } else {
            System.out.println("Failed to issue book!");
            request.setAttribute("errorMessage", "Failed to issue book. Please check server logs for details.");
            showIssueForm(request, response);
        }
        
    } catch (NumberFormatException e) {
        System.out.println("ERROR: Invalid number format - " + e.getMessage());
        request.setAttribute("errorMessage", "Invalid book or member ID");
        showIssueForm(request, response);
    } catch (ParseException e) {
        System.out.println("ERROR: Invalid date format - " + e.getMessage());
        request.setAttribute("errorMessage", "Invalid date format. Please use YYYY-MM-DD format.");
        showIssueForm(request, response);
    } catch (Exception e) {
        System.out.println("ERROR: Unexpected exception - " + e.getMessage());
        e.printStackTrace();
        request.setAttribute("errorMessage", "An unexpected error occurred: " + e.getMessage());
        showIssueForm(request, response);
    } finally {
        System.out.println("====== END ISSUE BOOK DEBUG ======");
    }
}
    private void listOverdueBooks(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Get overdue books
        List<IssuedBook> overdueBooks = issuedBookDAO.getOverdueBooks();
        
        // Set attributes
        request.setAttribute("issuedBooks", overdueBooks);
        request.setAttribute("now", new Timestamp(System.currentTimeMillis()));
        request.setAttribute("isOverdueView", true);
        
        // Forward to issued books list page
        request.getRequestDispatcher("/admin/issued-books/overdue.jsp").forward(request, response);
    }
    
    private void processExtension(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
    // Get parameters
    String issuedBookId = request.getParameter("id");
    String action = request.getParameter("extensionAction");
    String newDueDateStr = request.getParameter("newDueDate");
    
    System.out.println("Processing extension for issued book ID: " + issuedBookId);
    
    // Validate input
    if (issuedBookId == null || issuedBookId.isEmpty() ||
        action == null || action.isEmpty()) {
        
        request.setAttribute("errorMessage", "Issued book ID and action are required");
        listIssuedBooks(request, response);
        return;
    }
    
    try {
        int issuedBookIdInt = Integer.parseInt(issuedBookId);
        
        // Get issued book to check its status
        IssuedBook issuedBook = issuedBookDAO.getIssuedBookById(issuedBookIdInt);
        if (issuedBook == null) {
            request.setAttribute("errorMessage", "Issued book record not found");
            listIssuedBooks(request, response);
            return;
        }
        
        // Check if the book has already been returned
        if ("RETURNED".equals(issuedBook.getReturnStatus())) {
            request.setAttribute("errorMessage", "Cannot process extension for already returned book");
            listIssuedBooks(request, response);
            return;
        }
        
        boolean approve = "approve".equals(action);
        
        if (approve && (newDueDateStr == null || newDueDateStr.isEmpty())) {
            request.setAttribute("errorMessage", "New due date is required for approval");
            listIssuedBooks(request, response);
            return;
        }
        
        Timestamp newDueDate = null;
        if (approve) {
            try {
                newDueDate = DateUtil.parseDate(newDueDateStr);
                
                // Ensure new due date is in the future
                Timestamp now = new Timestamp(System.currentTimeMillis());
                if (newDueDate.before(now)) {
                    request.setAttribute("errorMessage", "New due date must be in the future");
                    listIssuedBooks(request, response);
                    return;
                }
            } catch (ParseException e) {
                request.setAttribute("errorMessage", "Invalid date format. Use yyyy-MM-dd");
                listIssuedBooks(request, response);
                return;
            }
        }
        
        // Process extension request
        boolean success = issuedBookDAO.processExtensionRequest(issuedBookIdInt, approve, newDueDate);
        
        if (success) {
            request.setAttribute("successMessage", "Extension request " + (approve ? "approved" : "rejected") + " successfully");
        } else {
            request.setAttribute("errorMessage", "Failed to process extension request");
        }
        
        listIssuedBooks(request, response);
        
    } catch (NumberFormatException e) {
        request.setAttribute("errorMessage", "Invalid issued book ID");
        listIssuedBooks(request, response);
    }
}
}