package com.example.web.controller.admin.ThemeController;


import com.example.web.dao.ThemeDao;
import com.example.web.dao.model.Voucher;
import com.example.web.service.ThemeService;
import com.example.web.service.VoucherService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/admin/themes/update")
public class Update extends HttpServlet {
    private ThemeService themeService = new ThemeService();
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String themeId = req.getParameter("themeId");
        String themeName = req.getParameter("themeName");
        int id = Integer.parseInt(themeId);
        try {
            boolean isUpdate = themeService.updateTheme(id, themeName);
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
