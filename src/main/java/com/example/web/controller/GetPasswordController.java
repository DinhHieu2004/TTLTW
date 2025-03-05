package com.example.web.controller;

import com.example.web.dao.UserDao;
import com.example.web.dao.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;


import java.io.IOException;
import java.sql.SQLException;

@WebServlet(name = "getPasswordController", value = "/user/sendPassword")
public class GetPasswordController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");

        UserDao userDao = new UserDao();
        User user = null;
        try {
            user = userDao.findByEmail(email);
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }

        if (user == null) {
            request.setAttribute("errorMessage", "Email không tồn tại trong hệ thống!");
            request.getRequestDispatcher("/user/forgot_password.jsp").forward(request, response);
            return;
        }

        try {
            boolean isPasswordRecovered = userDao.passwordRecovery(email);

            if (isPasswordRecovered) {
                request.setAttribute("successMessage", "Mã kích hoạt đã được gửi tới email của bạn!");
            } else {
                request.setAttribute("errorMessage", "Đã xảy ra lỗi khi gửi email. Vui lòng thử lại sau!");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Đã xảy ra lỗi khi gửi email. Vui lòng thử lại sau!");
        }

        request.getRequestDispatcher("/user/forgot_password.jsp").forward(request, response);
    }
}


