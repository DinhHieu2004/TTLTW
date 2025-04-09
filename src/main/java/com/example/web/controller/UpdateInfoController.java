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
        Map<String, String> errors = new HashMap<>();

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.setStatus(401);
            errors.put("message", "Bạn chưa đăng nhập!");
            out.print(gson.toJson(errors));
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
        }
        else if ((currentUser.getGg_id()!= null || currentUser.getFb_id() != null)) {
            errors.put("errorEmail", "Tài khoản Google/Facebook không thể thay đổi email!");
        }
        else if (!email.matches("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$")) {
            errors.put("errorEmail", "Email không hợp lệ!");
        } else {
            try {
                User existingUser = userSerive.findByEmail(email);
                if (existingUser != null && existingUser.getId() != (currentUser.getId())) {
                    errors.put("errorEmail", "Email đã tồn tại!");
                }
            } catch (SQLException e) {
                response.setStatus(500);
                errors.put("message", "Lỗi hệ thống, vui lòng thử lại sau!");
                out.print(gson.toJson(errors));
                out.flush();
                return;
            }
        }

        if (phone != null && !phone.trim().isEmpty() && !phone.matches("\\d{10}")) {
            errors.put("errorPhone", "Số điện thoại không hợp lệ!");
        }

        if (!errors.isEmpty()) {
            response.setStatus(400);
            errors.put("message", "Vui lòng kiểm tra lại thông tin!");
            out.print(gson.toJson(errors));
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
                response.setStatus(200);
                session.setAttribute("user", currentUser);
            } else {
                response.setStatus(500);
                errors.put("message", "Đã xảy ra lỗi, vui lòng thử lại!");
            }
        } catch (SQLException e) {
            response.setStatus(500);
            e.printStackTrace();
            errors.put("message", "Lỗi hệ thống, vui lòng thử lại sau!");
        }

        out.print(gson.toJson(errors));
        out.flush();
    }
}

