/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mycompany.librarymanagementsystem.util;

/**
 *
 * @author DMC_Studio
 */
import com.mycompany.librarymanagementsystem.model.Admin;
import com.mycompany.librarymanagementsystem.model.Member;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

/**
 * Utility class for session management
 */
public class SessionUtil {
    private static final String ADMIN_SESSION_KEY = "adminUser";
    private static final String MEMBER_SESSION_KEY = "memberUser";
    
    /**
     * Store admin in session
     * @param request HttpServletRequest
     * @param admin Admin to store
     */
    public static void storeAdminInSession(HttpServletRequest request, Admin admin) {
        HttpSession session = request.getSession();
        session.setAttribute(ADMIN_SESSION_KEY, admin);
    }
    
    /**
     * Get admin from session
     * @param request HttpServletRequest
     * @return Admin object or null if not found
     */
    public static Admin getAdminFromSession(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            return (Admin) session.getAttribute(ADMIN_SESSION_KEY);
        }
        return null;
    }
    
    /**
     * Store member in session
     * @param request HttpServletRequest
     * @param member Member to store
     */
    public static void storeMemberInSession(HttpServletRequest request, Member member) {
        HttpSession session = request.getSession();
        session.setAttribute(MEMBER_SESSION_KEY, member);
    }
    
    /**
     * Get member from session
     * @param request HttpServletRequest
     * @return Member object or null if not found
     */
    public static Member getMemberFromSession(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            return (Member) session.getAttribute(MEMBER_SESSION_KEY);
        }
        return null;
    }
    
    /**
     * Check if admin is logged in
     * @param request HttpServletRequest
     * @return true if admin is logged in, false otherwise
     */
    public static boolean isAdminLoggedIn(HttpServletRequest request) {
        return getAdminFromSession(request) != null;
    }
    
    /**
     * Check if member is logged in
     * @param request HttpServletRequest
     * @return true if member is logged in, false otherwise
     */
    public static boolean isMemberLoggedIn(HttpServletRequest request) {
        return getMemberFromSession(request) != null;
    }
    
    /**
     * Invalidate session
     * @param request HttpServletRequest
     */
    public static void invalidateSession(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
    }
}