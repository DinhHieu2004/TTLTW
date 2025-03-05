package com.example.web.controller.admin.sizeController;


import com.example.web.service.SizeService;
import com.example.web.service.ThemeService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/admin/sizes/delete")
public class Delete extends HttpServlet {
    private SizeService sizeService = new SizeService();
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        String sizeId = request.getParameter("sizeId");
        int id = Integer.parseInt(sizeId);
        try {
            boolean isDeleted = sizeService.deleteSize(id);
            if (isDeleted) {
                request.setAttribute("message", "Xóa kích thước thành công!");
            } else {
                request.setAttribute("message", "Xóa kích thước thất bại!");
            }
        } catch (Exception e) {
            request.setAttribute("message", "Lỗi: " + e.getMessage());
        }
       response.sendRedirect("../products");
       // request.getRequestDispatcher("../products.jsp").forward(request, response);
    }


}