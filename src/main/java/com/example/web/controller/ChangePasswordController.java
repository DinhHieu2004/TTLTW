package com.example.web.controller;

import com.example.web.dao.UserDao;
import com.example.web.dao.model.User;
import com.example.web.service.AuthService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.io.PrintWriter;
import java.net.URLEncoder;
import java.sql.SQLException;

@WebServlet(name = "ChangePasswordController", value = "/change-password")
public class ChangePasswordController extends HttpServlet {
    private final AuthService authService = new AuthService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        PrintWriter out = response.getWriter();

        if (session == null || session.getAttribute("user") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            out.write("{\"message\": \"Phiên làm việc đã hết, vui lòng đăng nhập lại.\"}");
            return;
        }

        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        User currentUser = (User) session.getAttribute("user");

        try {
            boolean checkPass = authService.checkPassword(currentUser.getId(), currentPassword);
            if (!checkPass) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.write("{\"field\": \"currentPassword\", \"message\": \"Mật khẩu hiện tại không đúng!\"}");
                return;
            }

            if (!newPassword.equals(confirmPassword)) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.write("{\"field\": \"confirmPassword\", \"message\": \"Mật khẩu xác nhận không khớp!\"}");
                return;
            }
            if (authService.checkPassword(currentUser.getId(), newPassword)) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.write("{\"field\": \"newPassword\", \"message\": \"Mật khẩu mới không được trùng mật khẩu cũ!\"}");
                return;
            }

            boolean isUpdated = authService.updatePassword(currentUser.getId(), newPassword);
            if (isUpdated) {
                response.setStatus(HttpServletResponse.SC_OK);
                out.write("{\"message\": \"Đổi mật khẩu thành công!\"}");
            } else {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                out.write("{\"message\": \"Không thể cập nhật mật khẩu, vui lòng thử lại!\"}");
            }

        } catch (SQLException e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.write("{\"message\": \"Lỗi hệ thống, vui lòng thử lại sau!\"}");
        }
    }

}

