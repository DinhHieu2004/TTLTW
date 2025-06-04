package com.example.web.controller.admin.OrderController;


import com.example.web.service.OrderService;
import com.example.web.service.PaintingService;
import com.google.gson.JsonObject;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/admin/orders/restore")
public class Restore extends HttpServlet {
    private final OrderService orderService = new OrderService();


    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        JsonObject jsonResponse = new JsonObject();


        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        String pid = request.getParameter("orderId");

        try {
            boolean isRestore = orderService.restoreOrder(Integer.parseInt(pid));
            if (isRestore) {
                jsonResponse.addProperty("success", true);
                jsonResponse.addProperty("message", "khôi phục thành công!");
            } else {
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "khôi phục thất bại!");
            }
        } catch (Exception e) {
            jsonResponse.addProperty("success", false);
            jsonResponse.addProperty("message", "Lỗi: " + e.getMessage());
        }

        response.getWriter().write(jsonResponse.toString());
    }
}