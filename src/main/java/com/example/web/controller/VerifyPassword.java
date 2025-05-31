package com.example.web.controller;

import com.example.web.dao.model.User;
import com.example.web.service.AuthService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/verify-password")
public class VerifyPassword extends HttpServlet {
    private final AuthService authService = new AuthService();
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");

        String password = req.getParameter("password");
        HttpSession session = req.getSession(false);
        boolean isValid = false;
        int userId;

        if (password == null || password.isEmpty()) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            resp.getWriter().write("{\"valid\": false, \"error\": \"Password is required\"}");
            return;
        }
        try {
            User user = (User) session.getAttribute("user");
            userId = user.getId();
        } catch (ClassCastException e) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            resp.getWriter().write("{\"valid\": false, \"error\": \"Invalid session userId\"}");
            return;
        }

        try {
            isValid = authService.checkPassword(userId, password);
        } catch (SQLException e) {
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            resp.getWriter().write("{\"valid\": false, \"error\": \"Server error\"}");
            return;
        }

        String jsonResponse = "{\"valid\": " + isValid + "}";
        resp.getWriter().write(jsonResponse);
    }
}
