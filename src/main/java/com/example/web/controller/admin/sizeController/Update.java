package com.example.web.controller.admin.sizeController;


import com.example.web.controller.util.CheckPermission;
import com.example.web.dao.model.User;
import com.example.web.service.SizeService;
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

@WebServlet("/admin/sizes/update")
public class Update extends HttpServlet {
    private final SizeService sizeService = new SizeService();
    private final String permission ="UPDATE_SIZES";


    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");
        PrintWriter out = resp.getWriter();

        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("user");

        boolean hasPermission = CheckPermission.checkPermission(user, permission, "ADMIN");
        if (!hasPermission) {
            out.write("{\"success\": true, \"message\": \"bạn không có quyền\"}");
            return;
        }



        try {
            int id = Integer.parseInt(req.getParameter("sizeId"));
            String description = req.getParameter("description");

            boolean isUpdated = sizeService.updateSize(id, description);

            if (isUpdated) {
                out.write("{\"success\": true, \"message\": \"Cập nhật thành công!\"}");
            } else {
                out.write("{\"success\": false, \"message\": \"Cập nhật thất bại.\"}");
            }
        } catch (Exception e) {
            out.write("{\"success\": false, \"message\": \"Lỗi: " + e.getMessage() + "\"}");
        }
        out.flush();
    }
}

