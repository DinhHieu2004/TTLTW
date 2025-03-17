package com.example.web.controller.admin.paintingController;


import com.example.web.service.PaintingService;
import com.example.web.service.UserSerive;
import com.google.gson.JsonObject;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/admin/products/delete")
public class Delete extends HttpServlet {
    private final PaintingService paintingService = new PaintingService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        String pid = request.getParameter("pid");
        JsonObject jsonResponse = new JsonObject();

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


