package com.example.web.controller;

import com.example.web.dao.model.User;
import com.example.web.dao.model.UserToken;
import com.example.web.service.AuthService;
import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

@WebServlet("/activate_account")
public class ActivateAccount extends HttpServlet {
    private final AuthService authService = new AuthService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String token = req.getParameter("token");
        String status;

        if (token == null || token.isEmpty()) {
            status = "INVALID_TOKEN";
        } else {
            try {
                UserToken userToken = authService.findByToken(token);
                if (userToken == null) {
                    status = "TOKEN_NOT_FOUND";
                } else if (userToken.getExpiredAt().before(new Timestamp(System.currentTimeMillis()))) {
                    status = "TOKEN_EXPIRED";
                } else {
                    User user = authService.findById(userToken.getUserId());
                    if (user.isActivated()) {
                        status = "ALREADY_ACTIVATED";
                    } else {
                        boolean isActivated = authService.activateUserByToken(token);
                        status = isActivated ? "ACTIVATED" : "ACTIVATION_FAILED";
                    }
                }
            } catch (SQLException e) {
                e.printStackTrace();
                status = "ERROR";
            }
        }

        req.setAttribute("status", status);
        req.getRequestDispatcher("/user/activateAcc.jsp").forward(req, resp);
    }
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");
        PrintWriter out = resp.getWriter();

        String email = req.getParameter("email");
        Map<String, String> errors = new HashMap<>();

        if (email == null || email.trim().isEmpty()) {
            resp.setStatus(400);
            errors.put("error", "Email không được để trống.");
        } else {
            try {
                User user = authService.findUserByEmail(email);
                if (user == null || user.isActivated()) {
                    resp.setStatus(400);
                    errors.put("error", "Email không hợp lệ hoặc tài khoản đã kích hoạt.");
                } else {
                    if (authService.hasValidToken(user)) {
                        resp.setStatus(400);
                        errors.put("error", "Đã có yêu cầu gửi lại liên kết. Vui lòng thử lại sau khi liên kết cũ hết hạn.");
                    } else {
                        String token = UUID.randomUUID().toString();
                        authService.resendToken(user, token);
                        resp.setStatus(200);
                        Map<String, String> successResponse = new HashMap<>();
                        successResponse.put("message", "Đã gửi lại liên kết, vui lòng kiểm tra email.");
                        out.print(new Gson().toJson(successResponse));
                        out.flush();
                        return;
                    }
                }
            } catch (Exception e) {
                resp.setStatus(500);
                errors.put("error", "Lỗi hệ thống, vui lòng thử lại sau.");
            }
        }

        out.print(new Gson().toJson(errors));
        out.flush();
    }

}

