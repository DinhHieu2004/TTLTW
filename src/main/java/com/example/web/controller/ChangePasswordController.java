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
import java.net.URLEncoder;
import java.sql.SQLException;

@WebServlet(name = "ChangePasswordController", value = "/change-password")
public class ChangePasswordController extends HttpServlet {
    AuthService auth = new AuthService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false); // Lấy session nếu có, không tạo mới


        // Lấy thông tin từ form
        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        // Lấy đối tượng User từ session
        User currentUser = (User) session.getAttribute("user"); // Đảm bảo dùng đúng tên "user"


        UserDao userDao = new UserDao();

        try {
            // Lấy mật khẩu hiện tại từ cơ sở dữ liệu
            String storedPassword = userDao.getPasswordByUsername(currentUser.getUsername());
            if (storedPassword == null || !auth.hashPassword(currentPassword).equals(storedPassword)) {
                // Mật khẩu hiện tại không đúng
                request.setAttribute("errorMessage", "Mật khẩu hiện tại không đúng!");
                request.getRequestDispatcher("/user/personal.jsp").forward(request, response);
                return;
            }

            // Kiểm tra mật khẩu mới và xác nhận mật khẩu
            if (!newPassword.equals(confirmPassword)) {
                request.setAttribute("errorMessage", "Mật khẩu mới và xác nhận mật khẩu không khớp!");
                request.getRequestDispatcher("/user/personal.jsp").forward(request, response);
                return;
            }

            // Cập nhật mật khẩu mới vào cơ sở dữ liệu
            boolean isUpdated = userDao.updatePassword(currentUser.getId(), newPassword);
            if (isUpdated) {
                request.setAttribute("successMessage", "Thay đổi mật khẩu thành công!");
            } else {
                request.setAttribute("errorMessage", "Đã xảy ra lỗi, vui lòng thử lại!");
            }

            request.getRequestDispatcher("/user/personal.jsp").forward(request, response);

        } catch (SQLException | IOException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Lỗi hệ thống, vui lòng thử lại sau!");
            request.getRequestDispatcher("/user/personal.jsp").forward(request, response);
        }
    }
}

