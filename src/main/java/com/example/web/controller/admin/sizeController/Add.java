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
import java.sql.SQLException;

@WebServlet("/admin/sizes/add")
public class Add extends HttpServlet {
    private final SizeService sizeService = new SizeService();

    private final String permission ="ADD_SIZES";


    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String description = req.getParameter("description");
        String sizeWeight = req.getParameter("sizeWeight");

        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");

        HttpSession session = req.getSession();
        User userC = (User) session.getAttribute("user");

        boolean hasPermission = CheckPermission.checkPermission(userC, permission, "ADMIN");
        if (!hasPermission) {
            //resp.sendRedirect(req.getContextPath() + "/NoPermission.jsp");

            resp.getWriter().write("{\"success\": false, \"message\": \"Bạn không có quyền.\"}");
            return;
        }



        try {
            boolean isAdd = sizeService.addSize(description, sizeWeight);
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
