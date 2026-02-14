package com.mycompany.librarymanagementsystem.controller.member;

import com.mycompany.librarymanagementsystem.dao.IssuedBookDAO;
import com.mycompany.librarymanagementsystem.model.IssuedBook;
import com.mycompany.librarymanagementsystem.model.Member;
import com.mycompany.librarymanagementsystem.util.SessionUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/member/history")
public class MemberHistoryController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private IssuedBookDAO issuedBookDAO;
    
    @Override
    public void init() throws ServletException {
        issuedBookDAO = new IssuedBookDAO();
    }
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        System.out.println("=== MemberHistoryController.doGet START ===");
        
        // Get member from session
        Member member = SessionUtil.getMemberFromSession(request);
        if (member == null) {
            response.sendRedirect(request.getContextPath() + "/member-login");
            return;
        }
        System.out.println("Member ID: " + member.getId());
        
        // Get current timestamp
        Timestamp now = new Timestamp(System.currentTimeMillis());
        request.setAttribute("now", now);
        
                // Di MemberHistoryController.java pada metode doGet
        List<IssuedBook> allBorrowedBooks = issuedBookDAO.getAllIssuedBooksByMember(member.getId());
        request.setAttribute("allBorrowedBooks", allBorrowedBooks);
        // Calculate statistics
        int totalBorrowed = allBorrowedBooks.size();
        int currentlyBorrowed = 0;
        int onTimeReturns = 0;
        int lateReturns = 0;
        
        for (IssuedBook book : allBorrowedBooks) {
            if ("NOT_RETURNED".equals(book.getReturnStatus())) {
                currentlyBorrowed++;
            } else if (book.getDateReturned() != null) {
                // Check if returned on time
                if (book.getDateReturned().before(book.getDueDate())) {
                    onTimeReturns++;
                } else {
                    lateReturns++;
                }
            }
        }
        
        System.out.println("Statistics - Total: " + totalBorrowed + 
                         ", Current: " + currentlyBorrowed + 
                         ", On-time: " + onTimeReturns + 
                         ", Late: " + lateReturns);
        
        // Set attributes
        request.setAttribute("totalBorrowed", totalBorrowed);
        request.setAttribute("currentlyBorrowed", currentlyBorrowed);
        request.setAttribute("onTimeReturns", onTimeReturns);
        request.setAttribute("lateReturns", lateReturns);
        request.setAttribute("recentActivity", allBorrowedBooks);
        
        // Generate borrowed categories data
        List<Map<String, Object>> borrowedCategories = generateBorrowedCategories(allBorrowedBooks);
        request.setAttribute("borrowedCategories", borrowedCategories);
        
        // Forward to history page
        System.out.println("Forward ke /member/history.jsp");
        request.getRequestDispatcher("/member/history.jsp").forward(request, response);
        
        System.out.println("=== MemberHistoryController.doGet END ===");
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
    
    // Helper method to generate borrowed categories
    private List<Map<String, Object>> generateBorrowedCategories(List<IssuedBook> books) {
        // This would normally come from a database with proper categories
        // For now, we'll categorize by book title first word as a demonstration
        Map<String, Integer> categoryCounts = new HashMap<>();
        Map<String, Timestamp> categoryLastBorrowed = new HashMap<>();
        
        for (IssuedBook book : books) {
            String title = book.getBookTitle();
            String category = "General";
            
            // Simple categorization based on first word of title
            if (title != null && !title.isEmpty()) {
                String[] words = title.split(" ");
                if (words.length > 0 && words[0].length() > 3) {
                    category = words[0];
                }
            }
            
            // Update count
            categoryCounts.put(category, categoryCounts.getOrDefault(category, 0) + 1);
            
            // Update last borrowed date if this is more recent
            Timestamp currentLastBorrowed = categoryLastBorrowed.get(category);
            if (currentLastBorrowed == null || book.getDateIssued().after(currentLastBorrowed)) {
                categoryLastBorrowed.put(category, book.getDateIssued());
            }
        }
        
        // Convert to list of maps
        List<Map<String, Object>> result = new ArrayList<>();
        for (String category : categoryCounts.keySet()) {
            Map<String, Object> categoryData = new HashMap<>();
            categoryData.put("name", category);
            categoryData.put("count", categoryCounts.get(category));
            categoryData.put("lastBorrowed", categoryLastBorrowed.get(category));
            result.add(categoryData);
        }
        
        return result;
    }
}