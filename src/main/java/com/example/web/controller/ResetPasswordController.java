package com.example.web.controller;

import com.example.web.dao.UserDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/user/reset_password")
public class ResetPasswordController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String token = request.getParameter("token");

        if (token == null || token.isEmpty()) {
            request.setAttribute("error", "Token không hợp lệ hoặc bị thiếu.");
            request.getRequestDispatcher("/user/reset_password.jsp").forward(request, response);
            return;
        }

        UserDao userDao = new UserDao();
        try {
            int userId = userDao.getUserIdByToken(token);

            if (userId == -1) {
                request.setAttribute("error", "Token không hợp lệ hoặc đã hết hạn.");
                request.getRequestDispatcher("/user/reset_password.jsp").forward(request, response);
                return;
            }

            // Token hợp lệ, chuyển tiếp đến form đổi mật khẩu
            request.setAttribute("token", token);
            request.getRequestDispatcher("/user/reset_password.jsp").forward(request, response);
        } catch (SQLException e) {
            throw new ServletException("Lỗi khi xác thực token", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String token = request.getParameter("token");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        if (token == null || token.isEmpty()) {
            request.setAttribute("error", "Token không hợp lệ hoặc bị thiếu.");
            request.getRequestDispatcher("/user/reset_password.jsp").forward(request, response);
            return;
        }

        if (newPassword == null || newPassword.isEmpty() || !newPassword.equals(confirmPassword)) {
            request.setAttribute("error", "Mật khẩu không khớp hoặc không hợp lệ.");
            request.setAttribute("token", token);
            request.getRequestDispatcher("/user/reset_password.jsp").forward(request, response);
            return;
        }

        UserDao userDao = new UserDao();
        try {
            int userId = userDao.getUserIdByToken(token);

            if (userId == -1) {
                request.setAttribute("error", "Token không hợp lệ hoặc đã hết hạn.");
                request.getRequestDispatcher("/user/reset_password.jsp").forward(request, response);
                return;
            }

            String username = userDao.getUser(userId).getUsername();
            boolean passwordUpdated = userDao.updatePassword(username, newPassword);

            if (passwordUpdated) {
                userDao.deleteToken(token);
                // Chuyển hướng đến trang thông báo thành công
                request.getRequestDispatcher("/user/success.jsp").forward(request, response);
            } else {
                request.setAttribute("error", "Không thể đổi mật khẩu.");
                request.getRequestDispatcher("/user/reset_password.jsp").forward(request, response);
            }
        } catch (SQLException e) {
            throw new ServletException("Lỗi khi xử lý đổi mật khẩu", e);
        }
    }
}
