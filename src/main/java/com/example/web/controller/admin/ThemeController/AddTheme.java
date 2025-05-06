package com.example.web.controller.admin.ThemeController;


import com.example.web.controller.util.CheckPermission;
import com.example.web.dao.model.User;
import com.example.web.service.ThemeService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;

@WebServlet("/admin/themes/add")
public class AddTheme extends HttpServlet {
    private final ThemeService themeService = new ThemeService();
    private final String permission ="ADD_THEMES";


    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        User userC = (User) session.getAttribute("user");

        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");

        boolean hasPermission = CheckPermission.checkPermission(userC, permission, "ADMIN");
        if (!hasPermission) {
            resp.getWriter().write("{\"success\": false, \"message\": \"Bạn không có quyền.\"}");

            //  resp.sendRedirect(req.getContextPath() + "/NoPermission.jsp");
            return;
        }

        String themeName = req.getParameter("themeName");
        PrintWriter out = resp.getWriter();

        User user = (User) req.getSession().getAttribute("user");

        if(!user.hasPermission("ADD_THEME")){
            resp.sendRedirect(req.getContextPath() + "/no-permission");
            return;
        }



        try {
            boolean isAdd = themeService.addTheme(themeName);
            if (isAdd) {
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
