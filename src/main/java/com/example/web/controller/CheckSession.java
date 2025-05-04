package com.example.web.controller;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/check-session")
public class CheckSession extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession session = req.getSession(false);

        if (session == null || session.getAttribute("uid") == null) {
            resp.setStatus(440);
            resp.setContentType("application/json");
            resp.getWriter().write("{\"message\": \"Phiên đăng nhập đã hết hạn.\"}");
        } else {
            resp.setStatus(200);
            resp.setContentType("application/json");
            resp.getWriter().write("{\"message\": \"OK\"}");
        }
    }
}
