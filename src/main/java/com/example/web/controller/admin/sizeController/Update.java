package com.example.web.controller.admin.sizeController;


import com.example.web.service.SizeService;
import com.example.web.service.ThemeService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/admin/sizes/update")
public class Update extends HttpServlet {
    private SizeService sizeService = new SizeService();
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String sizeId = req.getParameter("sizeId");
        String description = req.getParameter("description");
        int id = Integer.parseInt(sizeId);
        try {
            boolean isUpdate = sizeService.updateSize(id, description);
            if (isUpdate) {
                resp.sendRedirect("../products");
            } else {
                resp.getWriter().write("{\"success\": false, \"message\": \"Cập nhật thất bại.\"}");
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }
}
