package com.example.web.controller.admin.UserController;

import com.example.web.dao.UserDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;
@WebServlet("/admin/users/add")
public class Add  extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String fullName = request.getParameter("fullName");
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String address = request.getParameter("address");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");


        if (!password.equals(confirmPassword)) {
            request.setAttribute("errorMessage", "Mật khẩu và xác nhận mật khẩu không khớp.");
            request.setAttribute("fullName", fullName);
            request.setAttribute("username", username);
            request.setAttribute("address", address);
            request.setAttribute("email", email);
            request.setAttribute("phone", phone);
            request.getRequestDispatcher("index.jsp").forward(request, response);
            return;
        }

        try {
            UserDao userDao = new UserDao();

            if (userDao.findByUsername(username) != null) {
                request.setAttribute("errorMessage", "Tên đăng nhập đã tồn tại. Vui lòng chọn tên đăng nhập khác.");
                request.setAttribute("fullName", fullName);
                request.setAttribute("username", username);
                request.setAttribute("address", address);
                request.setAttribute("email", email);
                request.setAttribute("phone", phone);
                request.getRequestDispatcher("index.jsp").forward(request, response);
                return;
            }

            boolean isRegistered = userDao.registerUser(fullName, username, password, address, email, phone, "user");

            if (isRegistered) {
                request.setAttribute("message", "Thêm người dùng thành công!");
            } else {
                request.setAttribute("message", "Thêm người dùng thất bại!");
            }
        } catch (Exception e) {
            request.setAttribute("message", "Lỗi: " + e.getMessage());
        }
        request.getRequestDispatcher("../users.jsp").forward(request, response);
    }

}