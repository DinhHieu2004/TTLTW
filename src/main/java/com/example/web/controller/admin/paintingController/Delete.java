package com.example.web.controller.admin.paintingController;


import com.example.web.service.PaintingService;
import com.example.web.service.UserSerive;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/admin/products/delete")
public class Delete extends HttpServlet {
    private PaintingService paintingService = new PaintingService();
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        String pid = request.getParameter("pid");
        System.out.println(pid);
        try {
            boolean isDeleted = paintingService.deletePainting(Integer.parseInt(pid));
            if (isDeleted) {
                request.setAttribute("message", "Xóa tranh thành công!");
            } else {
                request.setAttribute("message", "Xóa tranh thất bại!");
            }
        } catch (Exception e) {
            request.setAttribute("message", "Lỗi: " + e.getMessage());
        }
       response.sendRedirect("../products");
       // request.getRequestDispatcher("../products.").forward(request, response);
    }


}

