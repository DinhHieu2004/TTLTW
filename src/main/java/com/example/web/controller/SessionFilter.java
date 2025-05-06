package com.example.web.controller;

import com.example.web.dao.model.User;
import com.example.web.utils.SessionManager;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.Set;


@WebFilter(urlPatterns = {"/admin/*", "/checkout"})
public class SessionFilter implements Filter {

    //có thể them api public,
    private static final Set<String> PUBLIC_PAGES = Set.of();

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;

        String requestURI = req.getRequestURI();

        for (String publicPage : PUBLIC_PAGES) {
            if (requestURI.endsWith(publicPage)) {
                chain.doFilter(request, response);
                return;
            }
        }

        String userId = (String) req.getSession().getAttribute("uid");

        if (userId == null || !SessionManager.userSessions.containsKey(userId)) {
            resp.sendRedirect(((HttpServletRequest) request).getContextPath() + "/.");
            return;
        }
        chain.doFilter(request, response);
    }

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
    }

    @Override
    public void destroy() {
    }
}

