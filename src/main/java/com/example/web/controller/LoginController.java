package com.example.web.controller;

import com.example.web.dao.model.User;
import com.example.web.service.AuthService;
import com.google.gson.Gson;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import jakarta.servlet.annotation.WebServlet;

@WebServlet(name = "LoginController", value = "/login")
public class LoginController extends HttpServlet {
    AuthService service = new AuthService();
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        Map<String, String> responseMap = new HashMap<>();
        try {
            User user = service.checkLogin(username, password);
            if (user != null) {
                HttpSession session = request.getSession();
                user.setPassword(null);
                session.setAttribute("user", user);
                System.out.println(user);
                responseMap.put("loginSuccess", "True");
                response.setStatus(HttpServletResponse.SC_OK);
            } else {
                responseMap.put("loginError", "Thông tin đăng nhập không đúng.");
                response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            responseMap.put("errorMess","Lỗi hệ thống, vui lòng thử lại sau!");
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        out.print(new Gson().toJson(responseMap));
        out.flush();
    }
}
