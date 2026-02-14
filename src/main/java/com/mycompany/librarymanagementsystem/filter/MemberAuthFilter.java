/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mycompany.librarymanagementsystem.filter;

/**
 *
 * @author DMC_Studio
 */
import com.mycompany.librarymanagementsystem.util.SessionUtil;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * Filter to protect member routes
 */
@WebFilter("/member/*")
public class MemberAuthFilter implements Filter {
    
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Initialization code if needed
    }
    
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        
        // Check if member is logged in
        if (SessionUtil.isMemberLoggedIn(httpRequest)) {
            // Member is authenticated, proceed with the request
            chain.doFilter(request, response);
        } else {
            // Member is not authenticated, redirect to login page
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/auth/member-login.jsp");
        }
    }
    
    @Override
    public void destroy() {
        // Cleanup code if needed
    }
}
