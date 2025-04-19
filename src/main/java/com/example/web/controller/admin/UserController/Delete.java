package com.example.web.controller.admin.UserController;
import com.example.web.controller.util.CheckPermission;
import com.example.web.dao.model.User;
import com.example.web.service.ArtistService;
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
import java.util.HashMap;
import java.util.Map;

@WebServlet("/admin/users/delete")
public class Delete extends HttpServlet {
    private UserSerive userSerive = new UserSerive();
    private final String permission= "DELETE_USERS";
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        boolean hasPermission = CheckPermission.checkPermission(user, permission, "ADMIN");
        if (!hasPermission) {
            response.sendRedirect(request.getContextPath() + "/NoPermission.jsp");
            return;
        }


        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        PrintWriter out = response.getWriter();
        Gson gson = new Gson();
        Map<String, Object> jsonResponse = new HashMap<>();

        String id = request.getParameter("id");
        System.out.println(id);

        try {
            boolean isDeleted = userSerive.deleteUser(Integer.parseInt(id));
            if (isDeleted) {
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
