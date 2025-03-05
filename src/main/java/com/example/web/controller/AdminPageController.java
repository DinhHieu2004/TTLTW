package com.example.web.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

public class AdminPageController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Lấy session từ request
        HttpSession session = request.getSession(false);

        // Kiểm tra nếu session không tồn tại hoặc không phải role admin
        if (session == null || !"admin".equals(session.getAttribute("role"))) {
            response.sendRedirect("index");  // Chuyển hướng về trang chủ nếu không phải admin
            return;
        }

        // Nếu là admin, chuyển hướng đến dashboard admin
        request.getRequestDispatcher("/admin").forward(request, response);  // Hiển thị dashboard admin
    }
}

