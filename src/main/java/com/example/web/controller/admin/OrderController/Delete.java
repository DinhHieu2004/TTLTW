package com.example.web.controller.admin.OrderController;

import com.example.web.dao.model.User;
import com.example.web.service.ArtistService;
import com.example.web.service.OrderService;
import com.google.gson.JsonObject;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;

@WebServlet("/admin/orders/delete")
public class Delete extends HttpServlet {
    private final OrderService orderService = new OrderService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        PrintWriter out = response.getWriter();

        User user = (User) request.getSession().getAttribute("user");
        boolean hasDeletePermission = user.hasPermission("DELETE_ORDERS");

        if (!hasDeletePermission) {
            out.write("{\"success\": true, \"message\": \"Bạn không có quyền.\"}");
            return;
        }

        try {
            String orderId = request.getParameter("orderId");
            boolean isDeleted = orderService.deleteOrder(Integer.parseInt(orderId));
            if (isDeleted) {
                out.write("{\"success\": true, \"message\": \"Xóa thành công.\"}");
            } else {
                out.write("{\"success\": false, \"message\": \"Xóa thất bại.\"}");
            }
        } catch (Exception e) {
            out.write("{\"success\": false, \"message\": \"Lỗi: " + e.getMessage() + "\"}");
        }
        finally {
            out.flush();
            out.close();
        }
    }
}
