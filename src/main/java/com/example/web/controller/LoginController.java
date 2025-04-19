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
    int CAPTCHA_EXPIRY_TIME = 2 * 60 * 1000;
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        HttpSession session = request.getSession(false);

        if (session != null && session.getAttribute("user") != null) {
            response.setStatus(HttpServletResponse.SC_FORBIDDEN);
            response.setContentType("application/json");
            response.getWriter().write("{\"success\": false, \"message\": \"Bạn đã đăng nhập rồi.\"}");
            return;
        }
        if (session == null) {
            session = request.getSession(true);
        }
        Map<String, String> responseMap = new HashMap<>();
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        int REQUEST_INTERVAL = 3000;
        int MAX_FAST_ATTEMPTS = 3;

        long currentTime = System.currentTimeMillis();
        Long lastLoginAttemptTime = (Long) session.getAttribute("lastLoginAttemptTime");
        int fastAttemptCount = session.getAttribute("fastAttemptCount") == null ? 0 : (int) session.getAttribute("fastAttemptCount");

        if (lastLoginAttemptTime != null && (currentTime - lastLoginAttemptTime) < REQUEST_INTERVAL) {
            fastAttemptCount++;
            session.setAttribute("fastAttemptCount", fastAttemptCount);

            if (fastAttemptCount >= MAX_FAST_ATTEMPTS) {
                response.setStatus(429);
                responseMap.put("errorMessage", "Bạn đang thao tác quá nhanh. Vui lòng chờ và thử lại.");
                PrintWriter out = response.getWriter();
                out.print(new Gson().toJson(responseMap));
                out.flush();
                return;
            }
        }
        session.setAttribute("lastLoginAttemptTime", currentTime);

        if (request.getSession().getAttribute("loginAttempts") == null) {
            request.getSession().setAttribute("loginAttempts", 0);
        }
        int loginAttempts = (int) request.getSession().getAttribute("loginAttempts");

        if (loginAttempts >= 5) {
            String captchaInput = request.getParameter("captcha");
            String captchaSession = (String) request.getSession().getAttribute("captcha");
            System.out.println(captchaInput);
            System.out.println(captchaSession);
            Long captchaCreationTime = (Long) session.getAttribute("captchaCreationTime");

            if (captchaCreationTime == null || (System.currentTimeMillis() - captchaCreationTime) > CAPTCHA_EXPIRY_TIME) {
                responseMap.put("loginCaptError", "CAPTCHA đã hết hạn. Vui lòng thử lại.");
                responseMap.put("captchaRequired", "true");
                response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                session.removeAttribute("captcha");
                session.removeAttribute("captchaCreationTime");

                PrintWriter out = response.getWriter();
                out.print(new Gson().toJson(responseMap));
                out.flush();
                return;
            } else if (captchaSession == null || !captchaSession.equals(captchaInput)) {
                responseMap.put("loginCaptError", "CAPTCHA không chính xác.");
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
                if (!user.isActivated()) {
                    responseMap.put("loginError", "Tài khoản chưa được kích hoạt. Vui lòng kiểm tra email để kích hoạt tài khoản.");
                    response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                } else {
                    user.setPassword(null);
                    session.setAttribute("user", user);
                    session.setAttribute("userId", user.getId());
                    session.setAttribute("loginAttempts", 0);
                    session.removeAttribute("captcha_code");
                    session.removeAttribute("captchaCreationTime");

                 //   System.out.println(user);

                    responseMap.put("loginSuccess", "True");
                    response.setStatus(HttpServletResponse.SC_OK);
                }
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
