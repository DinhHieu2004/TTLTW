package com.example.web.controller;

import com.example.web.dao.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpSession;

@WebFilter("/admin/*")
public class AdminFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
    }

    @Override
    public void doFilter(ServletRequest servletRequest, ServletResponse servletResponse, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest request = (HttpServletRequest) servletRequest;
        HttpServletResponse response = (HttpServletResponse) servletResponse;

        HttpSession session = request.getSession(false);
        User u = (session != null) ? (User) session.getAttribute("user") : null;

        if (u == null || u.getRoles() == null ||
                u.getRoles().stream().noneMatch(role -> role.getName().equals("ADMIN") || role.getName().startsWith("MANAGER"))) {
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }

        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
    }
}