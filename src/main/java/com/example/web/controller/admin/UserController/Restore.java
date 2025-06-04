package com.example.web.controller.admin.UserController;

import com.example.web.controller.util.CheckPermission;
import com.example.web.dao.model.User;
import com.example.web.service.UserService;
import com.google.gson.Gson;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

@WebServlet("/admin/users/restore")
public class Restore extends HttpServlet {
    private UserService userService = new UserService();
    private Gson gson = new Gson();
    private final String permission= "DELETE_USERS";

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");
        Map<String, Object> jsonResponse = new HashMap<>();

        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("user");

        boolean hasPermission = CheckPermission.checkPermission(user, permission, "ADMIN");
        if (!hasPermission) {
            jsonResponse.put("status", "error");
            jsonResponse.put("message", "bạn không có quyền");
            return;
        }

        try {
            int id = Integer.parseInt(req.getParameter("id"));
            User u = userService.getUser(id);

            User existingUser = userService.findByEmail(u.getEmail());
            if (existingUser != null) {
                jsonResponse.put("status", "error");
                jsonResponse.put("message", "Email đã tồn tại. Không thể khôi phục.");
                resp.getWriter().print(gson.toJson(jsonResponse));
                return;
            } else {
                boolean restored = userService.restoreUser(id);
                if (restored) {
                    jsonResponse.put("status", "success");
                    jsonResponse.put("message", "Khôi phục thành công!");
                } else {
                    jsonResponse.put("status", "error");
                    jsonResponse.put("message", "Không thể khôi phục.");
                }
            }
        } catch (Exception e) {
            jsonResponse.put("status", "error");
            jsonResponse.put("message", "Lỗi: " + e.getMessage());
        }

        resp.getWriter().print(gson.toJson(jsonResponse));
    }
}
