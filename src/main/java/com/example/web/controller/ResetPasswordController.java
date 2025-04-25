package com.example.web.controller;

import com.example.web.dao.UserDao;
import com.example.web.dao.model.User;
import com.example.web.dao.model.UserToken;
import com.example.web.service.AuthService;
import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.checkerframework.checker.units.qual.A;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.HashMap;
import java.util.Map;

@WebServlet("/reset_password")
public class ResetPasswordController extends HttpServlet {
    private final AuthService authService = new AuthService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String token = request.getParameter("token");
        String status;

        if (token == null || token.isEmpty()) {
            status = "INVALID_TOKEN";
        } else {
            try {
                UserToken userToken = authService.findByToken(token, "forgotPass");
                if (userToken == null) {
                    status = "TOKEN_NOT_FOUND";
                } else if (userToken.getExpiredAt().before(new Timestamp(System.currentTimeMillis()))) {
                    status = "TOKEN_EXPIRED";
                }else{
                    status = "VALID_TOKEN";
                    request.setAttribute("token", token);
                }
            } catch (SQLException e) {
                status = "ERROR";
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            }
        }
        request.setAttribute("status", status);
        request.getRequestDispatcher("/user/reset_password.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String token = request.getParameter("token");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        Map<String, Object> jsonResponse = new HashMap<>();
        Map<String, String> errors = new HashMap<>();

        if (token == null || token.isEmpty()) {
            errors.put("token", "Token không hợp lệ hoặc bị thiếu.");
        }

        if (newPassword == null || newPassword.isEmpty()) {
            errors.put("newPassword", "Vui lòng nhập mật khẩu mới.");
        } else if (!newPassword.equals(confirmPassword)) {
            errors.put("confirmPassword", "Mật khẩu xác nhận không khớp.");
        }

        if (!errors.isEmpty()) {
            response.setStatus(400);
            jsonResponse.put("status", "validation_error");
            jsonResponse.put("errors", errors);
            out.print(new Gson().toJson(jsonResponse));
            return;
        }

        try {
            String status = authService.handleResetPassword(token, newPassword);

            switch (status) {
                case "success":
                    response.setStatus(200);
                    jsonResponse.put("status", "success");
                    jsonResponse.put("message", "Mật khẩu đã được đổi thành công.");
                    break;
                case "token_expired":
                    response.setStatus(400);
                    jsonResponse.put("status", "token_expired");
                    jsonResponse.put("message", "Token đã hết hạn hoặc không hợp lệ.");
                    break;
                case "same_password":
                    response.setStatus(400);
                    jsonResponse.put("status", "same_password");
                    jsonResponse.put("message", "Mật khẩu mới không được trùng với mật khẩu hiện tại.");
                    break;
                case "update_failed":
                    response.setStatus(500);
                    jsonResponse.put("status", "update_failed");
                    jsonResponse.put("message", "Không thể cập nhật mật khẩu.");
                    break;
                default:
                    response.setStatus(500);
                    jsonResponse.put("status", "error");
                    jsonResponse.put("message", "Đã xảy ra lỗi không xác định.");
            }

        } catch (Exception e) {
            response.setStatus(500);
            jsonResponse.put("status", "error");
            jsonResponse.put("message", "Lỗi hệ thống: " + e.getMessage());
        }

        out.print(new Gson().toJson(jsonResponse));
        out.flush();
    }


}
