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

@WebServlet("/admin/sizes/add")
public class Add extends HttpServlet {
    private final SizeService sizeService = new SizeService();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String description = req.getParameter("description");

        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");

        try {
            boolean isAdd = sizeService.addSize(description);
            if (isAdd) {
                int newSizeId = sizeService.getLastInsertedId();
                resp.getWriter().write("{\"success\": true, \"id\": " + newSizeId + ", \"message\": \"Thêm thành công!\"}");
            } else {
                resp.getWriter().write("{\"success\": false, \"message\": \"Thêm thất bại.\"}");
            }
        } catch (SQLException e) {
            resp.getWriter().write("{\"success\": false, \"message\": \"Lỗi hệ thống.\"}");
        }
    }
}
