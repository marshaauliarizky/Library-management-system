package com.mycompany.librarymanagementsystem.controller.admin;

import com.mycompany.librarymanagementsystem.dao.IssuedBookDAO;
import com.mycompany.librarymanagementsystem.dao.MemberDAO;
import com.mycompany.librarymanagementsystem.model.Admin;
import com.mycompany.librarymanagementsystem.model.Member;
import com.mycompany.librarymanagementsystem.util.SessionUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import org.json.JSONObject;

@WebServlet("/admin/members")
public class MemberController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private MemberDAO memberDAO;
    
    @Override
    public void init() throws ServletException {
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
        
        if (action == null) {
            // Default action: list all members
            listMembers(request, response);
        } else {
            switch (action) {
                case "add":
                    showAddForm(request, response);
                    break;
                case "edit":
                    showEditForm(request, response);
                    break;
                case "delete":
                    deleteMember(request, response);
                    break;
                case "getDetails": 
                    getMemberDetails(request, response);
                     break;
                default:
                    listMembers(request, response);
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
        
        // Get action parameter
        String action = request.getParameter("action");
        
        if (action == null) {
            // Default action: list all members
            listMembers(request, response);
        } else {
            switch (action) {
                case "save":
                    saveMember(request, response);
                    break;
                case "search":
                    searchMembers(request, response);
                    break;
                default:
                    listMembers(request, response);
            }
        }
    }
    
    private void listMembers(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Get all members
        List<Member> members = memberDAO.getAllMembers();
        request.setAttribute("members", members);
        
        // Clear search parameter
        request.setAttribute("searchTerm", "");
        
        // Forward to members list page (pastikan path ini benar)
        request.getRequestDispatcher("/admin/members/list.jsp").forward(request, response);
    }
    /**
 * Get member details (AJAX)
 */
private void getMemberDetails(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
    // Get member ID
    String memberId = request.getParameter("id");
    
    if (memberId == null || memberId.isEmpty()) {
        response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
        response.getWriter().write("Member ID is required");
        return;
    }
    
    try {
        int id = Integer.parseInt(memberId);
        
        // Get member
        Member member = memberDAO.getMemberById(id);
        
        if (member == null) {
            response.setStatus(HttpServletResponse.SC_NOT_FOUND);
            response.getWriter().write("Member not found");
            return;
        }
        
        // Ambil jumlah buku yang dipinjam saat ini
        IssuedBookDAO issuedBookDAO = new IssuedBookDAO();
        int currentBooksCount = issuedBookDAO.getNotReturnedBooksByMemberId(id).size();
        
        // Create JSON response
        JSONObject json = new JSONObject();
        json.put("id", member.getId());
        json.put("name", member.getName());
        json.put("username", member.getUsername());
        json.put("phoneNumber", member.getPhoneNumber() != null ? member.getPhoneNumber() : "N/A");
        json.put("status", member.getStatus() != null ? member.getStatus() : "N/A");
        json.put("currentBooks", currentBooksCount);
        
        // Send JSON response
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write(json.toString());
        
    } catch (NumberFormatException e) {
        response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
        response.getWriter().write("Invalid member ID");
    }
}
    private void showAddForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Forward to add member form
        request.getRequestDispatcher("/admin/members/add.jsp").forward(request, response);
    }
    
    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Get member ID
        String memberId = request.getParameter("id");
        
        if (memberId == null || memberId.isEmpty()) {
            request.setAttribute("errorMessage", "Member ID is required");
            listMembers(request, response);
            return;
        }
        
        try {
            int id = Integer.parseInt(memberId);
            
            // Get member
            Member member = memberDAO.getMemberById(id);
            
            if (member == null) {
                request.setAttribute("errorMessage", "Member not found");
                listMembers(request, response);
                return;
            }
            
            // Set member attribute
            request.setAttribute("member", member);
            
            // Forward to edit member form
            request.getRequestDispatcher("/admin/members/edit.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid member ID");
            listMembers(request, response);
        }
    }
    
    private void saveMember(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Get form data
        String memberId = request.getParameter("id");
        String name = request.getParameter("name");
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String phoneNumber = request.getParameter("phoneNumber");
        String status = request.getParameter("status");
        
        // Validasi input
        if (name == null || name.isEmpty() ||
            username == null || username.isEmpty() ||
            phoneNumber == null || phoneNumber.isEmpty()) {
            
            request.setAttribute("errorMessage", "Name, username, and phone number are required");
            
            if (memberId == null || memberId.isEmpty()) {
                request.getRequestDispatcher("/admin/members/add.jsp").forward(request, response);
            } else {
                request.setAttribute("id", memberId);
                request.getRequestDispatcher("/admin/members?action=edit&id=" + memberId).forward(request, response);
            }
            return;
        }
        
        try {
            // Create member object
            Member member = new Member();
            member.setName(name);
            member.setUsername(username);
            member.setPhoneNumber(phoneNumber);
            
            if (status != null && !status.isEmpty()) {
                member.setStatus(status);
            } else {
                member.setStatus("ACTIVE");
            }
            
            boolean success;
            
            if (memberId == null || memberId.isEmpty()) {
                // Add new member
                if (password == null || password.isEmpty()) {
                    request.setAttribute("errorMessage", "Password is required for new member");
                    request.getRequestDispatcher("/admin/members/add.jsp").forward(request, response);
                    return;
                }
                
                // Check if username already exists
                Member existingMember = memberDAO.getMemberByUsername(username);
                if (existingMember != null) {
                    request.setAttribute("errorMessage", "Username already taken");
                    request.getRequestDispatcher("/admin/members/add.jsp").forward(request, response);
                    return;
                }
                
                member.setPassword(password);
                success = memberDAO.addMember(member);
                
                if (success) {
                    request.setAttribute("successMessage", "Member added successfully");
                } else {
                    request.setAttribute("errorMessage", "Failed to add member");
                }
            } else {
                // Update existing member
                int id = Integer.parseInt(memberId);
                member.setId(id);
                
                // Get existing member to preserve password if not changed
                Member existingMember = memberDAO.getMemberById(id);
                
                if (existingMember == null) {
                    request.setAttribute("errorMessage", "Member not found");
                    listMembers(request, response);
                    return;
                }
                
                // Check if username already exists (if changed)
                if (!username.equals(existingMember.getUsername())) {
                    Member usernameCheck = memberDAO.getMemberByUsername(username);
                    if (usernameCheck != null && usernameCheck.getId() != id) {
                        request.setAttribute("errorMessage", "Username already taken");
                        request.setAttribute("member", member);
                        request.getRequestDispatcher("/admin/members/edit.jsp").forward(request, response);
                        return;
                    }
                }
                
                boolean updatePassword = false;
                
                if (password != null && !password.isEmpty()) {
                    member.setPassword(password);
                    updatePassword = true;
                } else {
                    member.setPassword(existingMember.getPassword());
                }
                
                success = memberDAO.updateMember(member, updatePassword);
                
                if (success) {
                    request.setAttribute("successMessage", "Member updated successfully");
                } else {
                    request.setAttribute("errorMessage", "Failed to update member");
                }
            }
            
            // Redirect ke list members
            listMembers(request, response);
            
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid member ID");
            listMembers(request, response);
        }
    }
    
    private void deleteMember(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Get member ID
        String memberId = request.getParameter("id");
        
        if (memberId == null || memberId.isEmpty()) {
            request.setAttribute("errorMessage", "Member ID is required");
            listMembers(request, response);
            return;
        }
        
        try {
            int id = Integer.parseInt(memberId);
            
            // Delete member
            boolean success = memberDAO.deleteMember(id);
            
            if (success) {
                request.setAttribute("successMessage", "Member deleted successfully");
            } else {
                request.setAttribute("errorMessage", "Failed to delete member");
            }
            
            // Redirect ke list members
            listMembers(request, response);
            
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid member ID");
            listMembers(request, response);
        }
    }
    
    private void searchMembers(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Get search term
        String searchTerm = request.getParameter("searchTerm");
        
        if (searchTerm == null || searchTerm.isEmpty()) {
            listMembers(request, response);
            return;
        }
        
        // Search members
        List<Member> members = memberDAO.searchMembers(searchTerm);
        
        // Set attributes
        request.setAttribute("members", members);
        request.setAttribute("searchTerm", searchTerm);
        
        // Forward to members list page
        request.getRequestDispatcher("/admin/members/list.jsp").forward(request, response);
    }
}