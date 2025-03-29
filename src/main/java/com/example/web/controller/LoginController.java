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
        System.out.println("username: "+ username);
        System.out.println("pass: "+password);
        HttpSession session = request.getSession();
        Map<String, String> responseMap = new HashMap<>();

        if (request.getSession().getAttribute("loginAttempts") == null) {
            request.getSession().setAttribute("loginAttempts", 0);
        }
        int loginAttempts = (int) request.getSession().getAttribute("loginAttempts");

        if (loginAttempts >= 5) {
            String captchaInput = request.getParameter("captcha");
            String captchaSession = (String) request.getSession().getAttribute("captcha");
            System.out.println(captchaInput);
            System.out.println(captchaSession);
            if (captchaSession == null || !captchaSession.equals(captchaInput)) {
                responseMap.put("loginError", "CAPTCHA không chính xác.");
                response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                responseMap.put("captchaRequired", "true");
                PrintWriter out = response.getWriter();
                out.print(new Gson().toJson(responseMap));
                out.flush();
                return;
            }
        }
        try {
            User user = service.checkLogin(username, password);
            if (user != null) {
                user.setPassword(null);
                session.setAttribute("user", user);
                session.setAttribute("userId", user.getId());
                session.setAttribute("loginAttempts", 0);
                System.out.println(user);
                responseMap.put("loginSuccess", "True");
                response.setStatus(HttpServletResponse.SC_OK);
            } else {
                loginAttempts++;
                session.setAttribute("loginAttempts", loginAttempts);
                responseMap.put("loginError", "Thông tin đăng nhập không đúng.");
                response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                if (loginAttempts >= 5) {
                    responseMap.put("captchaRequired", "True");
                }
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
