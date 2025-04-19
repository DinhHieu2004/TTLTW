package com.example.web.controller.admin.ThemeController;


import com.example.web.controller.util.CheckPermission;
import com.example.web.dao.ThemeDao;
import com.example.web.dao.model.User;
import com.example.web.dao.model.Voucher;
import com.example.web.service.ThemeService;
import com.example.web.service.VoucherService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/admin/themes/update")
public class Update extends HttpServlet {
    private final ThemeService themeService = new ThemeService();

    private final String permission ="UPDATE_THEMES";


    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("user");

        boolean hasPermission = CheckPermission.checkPermission(user, permission, "ADMIN");
        if (!hasPermission) {
            resp.getWriter().write("{\"success\": false, \"message\": \"bạn không có quyền.\"}");
            return;
        }
        resp.setContentType("application/json"); // Định dạng JSON
        resp.setCharacterEncoding("UTF-8");

        String themeId = req.getParameter("themeId");
        String themeName = req.getParameter("themeName");

        if (themeId == null || themeName == null || themeId.trim().isEmpty() || themeName.trim().isEmpty()) {
            resp.getWriter().write("{\"success\": false, \"message\": \"Dữ liệu không hợp lệ.\"}");
            return;
        }

        try {
            int id = Integer.parseInt(themeId);
            boolean isUpdate = themeService.updateTheme(id, themeName);

            if (isUpdate) {
                resp.getWriter().write("{\"success\": true, \"message\": \"Cập nhật thành công.\"}");
            } else {
                resp.getWriter().write("{\"success\": false, \"message\": \"Cập nhật thất bại.\"}");
            }
        } catch (NumberFormatException e) {
            resp.getWriter().write("{\"success\": false, \"message\": \"ID không hợp lệ.\"}");
        } catch (SQLException e) {
            resp.getWriter().write("{\"success\": false, \"message\": \"Lỗi hệ thống: " + e.getMessage() + "\"}");
        }
    }
}

