package com.example.web.controller.admin.ThemeController;


import com.example.web.service.ThemeService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;

@WebServlet("/admin/themes/add")
public class AddTheme extends HttpServlet {
    private final ThemeService themeService = new ThemeService();
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");
        String themeName = req.getParameter("themeName");
        PrintWriter out = resp.getWriter();

        try {
            boolean isAdd = themeService.addTheme(themeName);
            if (isAdd) {
                // Lấy ID lớn nhất của theme vừa thêm
                int themeId = themeService.getLastInsertedId();
                out.write("{\"success\": true, \"id\": " + themeId + ", \"message\": \"Thêm thành công.\"}");
            } else {
                out.write("{\"success\": false, \"message\": \"Chủ đề tồn tại.\"}");
            }
        } catch (SQLException e) {
            out.write("{\"success\": false, \"message\": \"Lỗi hệ thống.\"}");
        } finally {
            out.flush();
        }
    }

}
