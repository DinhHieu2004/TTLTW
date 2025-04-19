package com.example.web.controller.admin.paintingController;


import com.example.web.controller.util.CheckPermission;
import com.example.web.dao.model.User;
import com.example.web.service.PaintingService;
import com.example.web.service.UserSerive;
import com.google.gson.JsonObject;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/admin/products/delete")
public class Delete extends HttpServlet {
    private final PaintingService paintingService = new PaintingService();
    private final String permission = "DELETE_PRODUCTS";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        JsonObject jsonResponse = new JsonObject();

        boolean hasPermission = CheckPermission.checkPermission(user, permission, "ADMIN");
        if (!hasPermission) {
            jsonResponse.addProperty("message", "bạn không có quyền!");
            return;
        }

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        String pid = request.getParameter("pid");

        try {
            boolean isDeleted = paintingService.deletePainting(Integer.parseInt(pid));
            if (isDeleted) {
                jsonResponse.addProperty("success", true);
                jsonResponse.addProperty("message", "Xóa tranh thành công!");
            } else {
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "Xóa tranh thất bại!");
            }
        } catch (Exception e) {
            jsonResponse.addProperty("success", false);
            jsonResponse.addProperty("message", "Lỗi: " + e.getMessage());
        }

        response.getWriter().write(jsonResponse.toString());
    }
}


