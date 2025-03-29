package com.example.web.controller.admin.UserController;

import com.example.web.dao.model.User;
import com.example.web.service.UserSerive;
import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;


@WebServlet("/admin/users/update")
public class Update extends HttpServlet {
    private UserSerive userSerive = new UserSerive();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");
        Gson gson = new Gson();
        Map<String, Object> responseMap = new HashMap<>();

        try {
            int id = Integer.parseInt(req.getParameter("id"));
            String username = req.getParameter("username");
            String email = req.getParameter("email");
            String phone = req.getParameter("phone");
            String address = req.getParameter("address");
            String fullName = req.getParameter("fullName");
            String role = req.getParameter("role");

            User.Role roleEnum = User.Role.valueOf(role);
            User user = new User(id, fullName, username, address, email, phone, roleEnum);

            boolean isUpdated = userSerive.updateUser(user);

            responseMap.put("success", isUpdated);
            responseMap.put("message", isUpdated ? "Cập nhật thành công!" : "Cập nhật thất bại!");
            if (isUpdated) {
                responseMap.put("user", user);
            }

        } catch (Exception e) {
            responseMap.put("success", false);
            responseMap.put("message", "Lỗi hệ thống: " + e.getMessage());
        }

        try (PrintWriter out = resp.getWriter()) {
            out.write(gson.toJson(responseMap));
            out.flush();
        }
    }
}
