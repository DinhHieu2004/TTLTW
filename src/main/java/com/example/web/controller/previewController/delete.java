package com.example.web.controller.previewController;


import com.example.web.service.PrivewService;
import com.example.web.service.VoucherService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

//@WebServlet("/admin/reviews/delete")
public class delete extends HttpServlet {
    private PrivewService privewService = new PrivewService();
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        String rid = request.getParameter("rid");
        int id = Integer.parseInt(rid);
        try {
            boolean isDeleted = privewService.deleteReviewById(id);
            if (isDeleted) {
                request.setAttribute("message", "Xóa đánh giá thành công!");
            } else {
                request.setAttribute("message", "Xóa  đánh giá thất bại!");
            }
        } catch (Exception e) {
            request.setAttribute("message", "Lỗi: " + e.getMessage());
        }
        response.sendRedirect("../reviews");
        //request.getRequestDispatcher("../artists.jsp").forward(request, response);
    }


}