package com.example.web.controller.admin.ThemeController;


import com.example.web.controller.util.GsonProvider;
import com.example.web.dao.model.Theme;
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

@WebServlet("/admin/themes/detail")
public class GetDetail extends HttpServlet {
    private final ThemeService themeService = new ThemeService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        int id = Integer.parseInt( req.getParameter("themeId"));

        try {
            Theme v = themeService.getThemeById(id);
            resp.setContentType("application/json");
            resp.setCharacterEncoding("UTF-8");
            resp.getWriter().write(GsonProvider.getGson().toJson(v));
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }
}
