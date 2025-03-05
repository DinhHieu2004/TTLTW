package com.example.web.controller.admin.ThemeController;


import com.example.web.service.ThemeService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/admin/themes/add")
public class AddTheme extends HttpServlet {
    private ThemeService themeService = new ThemeService();
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String themeName = req.getParameter("themeName");

        try {
            boolean isAdd = themeService.addTheme(themeName);
            if (isAdd) {
                resp.sendRedirect("../products");
            } else {
                resp.getWriter().write("{\"success\": false, \"message\": \"Them thất bại.\"}");
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }


    }
}
