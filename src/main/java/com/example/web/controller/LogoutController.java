package com.example.web.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "LogoutController", value = "/logout")
public class LogoutController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        logout(request, response);
    }
    private void logout(HttpServletRequest request, HttpServletResponse response) throws IOException {
        // Lấy session hiện tại
        HttpSession session = request.getSession(false); // Lấy session nếu có, không tạo mới

        if (session != null) {
            // Xóa session
            session.invalidate();
        }

        // Chuyển hướng người dùng về trang đăng nhập hoặc trang chủ
        response.sendRedirect(request.getContextPath() + "/");
    }
}


