package com.example.web.controller.admin.OrderController;

import com.example.web.controller.util.CheckPermission;
import com.example.web.dao.model.User;
import com.example.web.service.OrderService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;

@WebServlet("/update-order-status")
public class UpdateStatusOrder extends HttpServlet {
    private final OrderService orderService = new OrderService();
    private final String permission ="UPDATE_ORDERS";


    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        PrintWriter out = response.getWriter();


        boolean hasPermission = CheckPermission.checkPermission(user, permission, "ADMIN");
        if (!hasPermission) {
          //  response.sendRedirect(request.getContextPath() + "/NoPermission.jsp");

            out.write("{\"message\": \"ban không có quyền\"}");

            return;
        }
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");


        String orderIdStr = request.getParameter("orderId");
        String status = request.getParameter("deliveryStatus");
        String recipientName = request.getParameter("recipientName");
        String recipientPhone = request.getParameter("recipientPhone");
        String deliveryAddress = request.getParameter("deliveryAddress");


        if (orderIdStr == null || orderIdStr.isEmpty() || status == null || status.isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.write("{\"message\": \"Invalid input data\"}");
            out.flush();
            out.close();
            return;
        }

        try {
            int orderId = Integer.parseInt(orderIdStr);

            boolean updated = orderService.updateOrderStatus(orderId, status, recipientName, recipientPhone, deliveryAddress);

            if (updated) {
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
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.write("{\"message\": \"Database error: " + e.getMessage() + "\"}");
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.write("{\"message\": \"Unexpected error: " + e.getMessage() + "\"}");
        } finally {
            out.flush();
            out.close();
        }
    }
}

