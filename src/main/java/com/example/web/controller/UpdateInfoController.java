package com.example.web.controller;

import com.example.web.dao.UserDao;
import com.example.web.dao.model.User;
import com.example.web.service.UserSerive;
import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

@WebServlet(name = "updateInfo", value = "/update-personal-info")
public class UpdateInfoController extends HttpServlet {
    private UserSerive userSerive = new UserSerive();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        PrintWriter out = response.getWriter();
        Gson gson = new Gson();
        Map<String, Object> jsonResponse = new HashMap<>();
        Map<String, String> errors = new HashMap<>();

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            jsonResponse.put("status", "error");
            jsonResponse.put("message", "Bạn chưa đăng nhập!");
            out.print(gson.toJson(jsonResponse));
            out.flush();
            return;
        }

        User currentUser = (User) session.getAttribute("user");

        String fullName = request.getParameter("fullName");
        String phone = request.getParameter("phone");
        String email = request.getParameter("email");
        String address = request.getParameter("address");

        if (fullName == null || fullName.trim().isEmpty()) {
            errors.put("fullName", "Họ và tên không được để trống!");
        }

        if (email == null || email.trim().isEmpty()) {
            errors.put("errorEmail", "Email không được để trống!");
        } else if (!email.matches("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$")) {
            errors.put("errorEmail", "Email không hợp lệ!");
        } else {
            try {
                User existingUser = userSerive.findByEmail(email);
                if (existingUser != null && existingUser.getId() != (currentUser.getId())) {
                    errors.put("errorEmail", "Email đã tồn tại!");
                }
            } catch (SQLException e) {
                throw new RuntimeException(e);
            }
        }

        if (phone != null && !phone.trim().isEmpty() && !phone.matches("\\d{10}")) {
            errors.put("errorPhone", "Số điện thoại không hợp lệ!");
        }

        if (!errors.isEmpty()) {
            jsonResponse.put("status", "error");
            jsonResponse.put("message", "Vui lòng kiểm tra lại thông tin!");
            jsonResponse.put("errors", errors);
            out.print(gson.toJson(jsonResponse));
            out.flush();
            return;
        }

        try {
            currentUser.setFullName(fullName);
            currentUser.setPhone(phone);
            currentUser.setEmail(email);
            currentUser.setAddress(address);

            boolean isUpdated = userSerive.updateUserInfo(currentUser);
            if (isUpdated) {
                session.setAttribute("user", currentUser);
                jsonResponse.put("status", "success");
                jsonResponse.put("message", "Cập nhật thông tin thành công!");
                jsonResponse.put("updatedUser", currentUser);
            } else {
                jsonResponse.put("status", "error");
                jsonResponse.put("message", "Đã xảy ra lỗi, vui lòng thử lại!");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            jsonResponse.put("status", "error");
            jsonResponse.put("message", "Lỗi hệ thống, vui lòng thử lại sau!");
        }

        out.print(gson.toJson(jsonResponse));
        out.flush();
    }
}

