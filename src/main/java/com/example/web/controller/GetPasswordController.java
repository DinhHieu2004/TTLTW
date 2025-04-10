package com.example.web.controller;

import com.example.web.dao.UserDao;
import com.example.web.dao.model.User;
import com.example.web.service.AuthService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;


import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/sendPassword")
public class GetPasswordController extends HttpServlet {
    private final AuthService authService = new AuthService();
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        User user = null;

        try {
            user = authService.findUserByEmail(email);
        } catch (SQLException e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"status\":\"error\",\"message\":\"Lỗi hệ thống khi kiểm tra email.\"}");
            return;
        }

        if (user == null) {
            response.setStatus(HttpServletResponse.SC_NOT_FOUND);
            response.getWriter().write("{\"status\":\"error\",\"message\":\"Email không tồn tại trong hệ thống!\"}");
            return;
        }

        try {
            boolean isPasswordRecovered = authService.passwordRecovery(email);

            if (isPasswordRecovered) {
                response.setStatus(HttpServletResponse.SC_OK);
                response.getWriter().write("{\"status\":\"success\",\"message\":\"Mã khôi phục đã được gửi tới email của bạn!\"}");
            } else {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                response.getWriter().write("{\"status\":\"error\",\"message\":\"Không thể gửi email. Vui lòng thử lại sau!\"}");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"status\":\"error\",\"message\":\"Đã xảy ra lỗi khi gửi email. Vui lòng thử lại sau!\"}");
        }
    }
}


