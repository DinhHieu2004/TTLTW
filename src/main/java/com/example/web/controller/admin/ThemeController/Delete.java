package com.example.web.controller.admin.ThemeController;


import com.example.web.service.ThemeService;
import com.example.web.service.VoucherService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;

@WebServlet("/admin/themes/delete")
public class Delete extends HttpServlet {
    private final ThemeService themeService = new ThemeService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        PrintWriter out = response.getWriter();
        String themeId = request.getParameter("themeId");

        try {
            int id = Integer.parseInt(themeId);
            boolean isDeleted = themeService.deleteTheme(id);

            if (isDeleted) {
                out.write("{\"success\": true, \"message\": \"Xóa chủ đề thành công.\"}");
            } else {
                out.write("{\"success\": false, \"message\": \"Xóa chủ đề thất bại.\"}");
            }
        } catch (Exception e) {
            out.write("{\"success\": false, \"message\": \"Lỗi: " + e.getMessage() + "\"}");
        } finally {
            out.flush();
        }
    }
}
