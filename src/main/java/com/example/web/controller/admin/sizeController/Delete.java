package com.example.web.controller.admin.sizeController;


import com.example.web.service.SizeService;
import com.example.web.service.ThemeService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;

@WebServlet("/admin/sizes/delete")
public class Delete extends HttpServlet {
    private final SizeService sizeService = new SizeService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        try {
            int id = Integer.parseInt(request.getParameter("sizeId"));
            boolean isDeleted = sizeService.deleteSize(id);

            if (isDeleted) {
                out.write("{\"success\": true, \"message\": \"Xóa kích thước thành công!\"}");
            } else {
                out.write("{\"success\": false, \"message\": \"Xóa kích thước thất bại!\"}");
            }
        } catch (Exception e) {
            out.write("{\"success\": false, \"message\": \"Lỗi: " + e.getMessage() + "\"}");
        }
        out.flush();
    }
}
