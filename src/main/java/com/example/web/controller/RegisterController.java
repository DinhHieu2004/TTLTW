package com.example.web.controller;

import com.example.web.dao.UserDao;
import com.example.web.service.AuthService;
import com.example.web.service.UserSerive;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;

@WebServlet(name = "RegisterController", value = "/register")
public class RegisterController extends HttpServlet {
    AuthService auth = new AuthService();
    UserSerive userSerive = new UserSerive();
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Lấy thông tin từ form đăng ký
        String fullName = request.getParameter("fullName");
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String address = request.getParameter("address");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");


        // Kiểm tra mật khẩu và xác nhận mật khẩu
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

            if (userSerive.findByUsername(username) != null) {
                request.setAttribute("errorMessage", "Tên đăng nhập đã tồn tại. Vui lòng chọn tên đăng nhập khác.");
                request.setAttribute("fullName", fullName);
                request.setAttribute("username", username);
                request.setAttribute("address", address);
                request.setAttribute("email", email);
                request.setAttribute("phone", phone);
                request.getRequestDispatcher("index.jsp").forward(request, response);
                return;
            }

            // Đăng ký người dùng mới
            boolean isRegistered = auth.registerUser(fullName, username, password, address, email, phone, "user");

            if (isRegistered) {
                // Đăng ký thành công, chuyển hướng tới trang đăng nhập
                String successMessage = "Đăng ký thành công! Bạn có thể đăng nhập ngay.";
                response.setContentType("text/html");
                response.getWriter().write("<script type='text/javascript'>"
                        + "alert('" + successMessage + "');"
                        + "window.location.href = 'index.jsp';"
                        + "</script>");
            } else {
                // Đăng ký thất bại, thông báo lỗi
                request.setAttribute("errorMessage", "Đăng ký không thành công. Vui lòng thử lại.");
                request.getRequestDispatcher("index.jsp").forward(request, response);
            }
        } catch (SQLException e) {
            throw new RuntimeException("Lỗi khi thực hiện đăng ký", e);
        }
    }
}
