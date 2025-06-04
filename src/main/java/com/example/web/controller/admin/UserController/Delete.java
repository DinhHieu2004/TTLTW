package com.example.web.controller.admin.UserController;
import com.example.web.controller.util.CheckPermission;
import com.example.web.dao.model.User;
import com.example.web.service.UserService;
import com.example.web.utils.SessionManager;
import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Map;

@WebServlet("/admin/users/delete")
public class Delete extends HttpServlet {
    private UserService userService = new UserService();
    private final String permission= "DELETE_USERS";
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        PrintWriter out = response.getWriter();
        Gson gson = new Gson();
        Map<String, Object> jsonResponse = new HashMap<>();


        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        boolean hasPermission = CheckPermission.checkPermission(user, permission, "ADMIN");
        if (!hasPermission) {
            jsonResponse.put("status", "error");
            jsonResponse.put("message", "bạn không có quyền");
            return;
        }



        String id = request.getParameter("id");
        System.out.println(id);

        try {
            if (user.getId() == Integer.parseInt(id)) {
                jsonResponse.put("status", "error");
                jsonResponse.put("message", "Bạn không thể tự xóa chính mình!");
                out.print(gson.toJson(jsonResponse));
                out.flush();
                return;
            }

            User userToDelete = userService.getUser(Integer.parseInt(id));
            boolean isAdmin = userToDelete.getRoles().stream()
                    .anyMatch(role -> "ADMIN".equalsIgnoreCase(role.getName()));
            if (isAdmin) {
                jsonResponse.put("status", "error");
                jsonResponse.put("message", "Không thể xóa người dùng có quyền ADMIN!");
                out.print(gson.toJson(jsonResponse));
                out.flush();
                return;
            }
            boolean isDeleted = userService.deleteUser(Integer.parseInt(id));
            if (isDeleted) {
                User up = userService.getUser(Integer.parseInt(id));

                HttpSession userSession = SessionManager.userSessions.get(up.getId()+"");
                if (userSession != null) {
                    userSession.invalidate();
                    SessionManager.userSessions.remove(up.getEmail());
                }
                jsonResponse.put("status", "success");
                jsonResponse.put("message", "Xóa người dùng thành công!");
            } else {
                jsonResponse.put("status", "error");
                jsonResponse.put("message", "Xóa người dùng thất bại!");
            }
        } catch (Exception e) {
            jsonResponse.put("status", "error");
            jsonResponse.put("message", "Lỗi: " + e.getMessage());
        }

        out.print(gson.toJson(jsonResponse));
        out.flush();
    }
}
