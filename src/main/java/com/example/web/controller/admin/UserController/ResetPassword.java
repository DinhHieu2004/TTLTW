package com.example.web.controller.admin.UserController;

import com.example.web.service.UserService;
import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Map;

@WebServlet("/admin/users/reset_pass")
public class ResetPassword extends HttpServlet {
    private Gson gson = new Gson();
    private UserService userService = new UserService();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String userId = req.getParameter("userId");
        String newPass = req.getParameter("newPassword");
        String confirmPassword = req.getParameter("confirmPass");

        Map<String, String> errors = new HashMap<>();
        Map<String, Object> responseData = new HashMap<>();

        resp.setContentType("application/json");
        PrintWriter out = resp.getWriter();

        if (newPass == null || confirmPassword == null || !newPass.equals(confirmPassword)) {
            errors.put("confirmError", "Mật khẩu và xác nhận không khớp.");
        }
        if (userId == null || userId.isEmpty()) {
            errors.put("userIdError", "Thiếu userId.");
        }

        if (!errors.isEmpty()) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            responseData.put("status", "error");
            responseData.put("errors", errors);
            out.print(gson.toJson(responseData));
            return;
        }

        try {
            boolean changed = userService.changePassword(Integer.parseInt(userId), newPass);

            if (changed) {
                resp.setStatus(HttpServletResponse.SC_OK);
                responseData.put("status", "success");
                responseData.put("message", "Đổi mật khẩu thành công.");
            } else {
                resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                responseData.put("status", "error");
                errors.put("serverError", "Không thể đổi mật khẩu.");
                responseData.put("errors", errors);
            }
        } catch (Exception e) {
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            responseData.put("status", "error");
            errors.put("serverError", "Lỗi server nội bộ.");
            responseData.put("errors", errors);
        }

        out.print(gson.toJson(responseData));
    }
}
