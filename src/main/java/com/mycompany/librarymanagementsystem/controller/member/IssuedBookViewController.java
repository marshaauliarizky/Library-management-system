/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mycompany.librarymanagementsystem.controller.member;

/**
 *
 * @author DMC_Studio
 */

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
import java.util.List;

@WebServlet("/member/issued-books")
public class IssuedBookViewController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private IssuedBookDAO issuedBookDAO;
    
    @Override
    public void init() throws ServletException {
        issuedBookDAO = new IssuedBookDAO();
    }
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Get member from session
        Member member = SessionUtil.getMemberFromSession(request);
        if (member == null) {
            response.sendRedirect(request.getContextPath() + "/member-login");
            return;
        }
        
        // Get current timestamp
        Timestamp now = new Timestamp(System.currentTimeMillis());
        request.setAttribute("now", now);
        
        // Get member's currently borrowed books
        List<IssuedBook> currentlyBorrowedBooks = issuedBookDAO.getIssuedBooksByMember(member.getId());
        request.setAttribute("currentlyBorrowedBooks", currentlyBorrowedBooks);
        
        // Get member's returned books
        List<IssuedBook> returnedBooks = issuedBookDAO.getReturnedBooksByMember(member.getId());
        request.setAttribute("returnedBooks", returnedBooks);
        
        // Forward to issued books page
        request.getRequestDispatcher("/member/issued-books.jsp").forward(request, response);
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
