package com.example.web.controller;

import com.example.web.dao.model.User;
import com.example.web.service.AuthService;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import jakarta.servlet.annotation.WebServlet;

@WebServlet(name = "LoginController", value = "/login")
public class LoginController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        AuthService service = new AuthService();
        try {
            User user = service.checkLogin(username, password);
            if (user != null && user.getRole() != null) { // Kiểm tra user có khác null và có role
                HttpSession session = request.getSession();
                session.setAttribute("user", user);
                User currentUser = (User) session.getAttribute("user");
                System.out.println(currentUser);
                response.sendRedirect(request.getContextPath() + "/");

            } else {
                request.setAttribute("errorMessage", "Tên đăng nhập hoặc mật khẩu không đúng!");
                response.sendRedirect(request.getContextPath() + "/");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Lỗi hệ thống, vui lòng thử lại sau!");
            response.sendRedirect(request.getContextPath() + "/");
        }
    }
}
