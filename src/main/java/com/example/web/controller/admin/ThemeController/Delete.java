package com.example.web.controller.admin.ThemeController;


import com.example.web.service.ThemeService;
import com.example.web.service.VoucherService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/admin/themes/delete")
public class Delete extends HttpServlet {
    private ThemeService themeService = new ThemeService();
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        String themeId = request.getParameter("themeId");
        int id = Integer.parseInt(themeId);
        try {
            boolean isDeleted = themeService.deleteTheme(id);
            if (isDeleted) {
                request.setAttribute("message", "Xóa chủ đề thành công!");
            } else {
                request.setAttribute("message", "Xóa chủ đề thất bại!");
            }
        } catch (Exception e) {
            request.setAttribute("message", "Lỗi: " + e.getMessage());
        }
        response.sendRedirect("../products");
       // request.getRequestDispatcher("../products.jsp").forward(request, response);
    }


}