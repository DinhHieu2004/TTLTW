package com.example.web.controller.admin.OrderController;

import com.example.web.service.OrderService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;

@WebServlet("/update-order-status")
public class UpdateStatusOrder extends HttpServlet {
    private OrderService orderService= new OrderService();
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();

        String orderIdStr = request.getParameter("orderId");
        String status = request.getParameter("status");
        String recipientName = request.getParameter("recipientName");
        String recipientPhone = request.getParameter("recipientPhone");
        String deliveryAddress = request.getParameter("deliveryAddress");
        System.out.println(orderIdStr);




        if (orderIdStr == null || orderIdStr.isEmpty() || status == null || status.isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.write("{\"message\": \"Invalid input data\"}");
            return;
        }

        try {
            int orderId = Integer.parseInt(orderIdStr);

            if (orderService.updateOrderStatus(orderId, status,recipientName,recipientPhone, deliveryAddress)) {
                response.setStatus(HttpServletResponse.SC_OK);
                out.write("{\"message\": \"Order status updated successfully\"}");
            } else {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                out.write("{\"message\": \"Failed to update order status\"}");
            }

        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.write("{\"message\": \"Invalid orderId format\"}");
        } catch (SQLException e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.write("{\"message\": \"Database error\"}");
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

}
