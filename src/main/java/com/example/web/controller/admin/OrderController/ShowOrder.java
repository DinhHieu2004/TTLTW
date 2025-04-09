package com.example.web.controller.admin.OrderController;

import com.example.web.dao.model.Order;
import com.example.web.service.OrderService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/admin/orders")

public class ShowOrder extends HttpServlet {
    OrderService orderService = new OrderService();

    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        try {
            List<Order> currentOrder = orderService.getOrderCurrentAdmin();
            List<Order> historyOrder = orderService.getOrderHistoryAdmin();

            req.setAttribute("currentOrder",currentOrder);
            req.setAttribute("historyOrder",historyOrder);
            req.getRequestDispatcher("orders.jsp").forward(req, resp);

        } catch (Exception e) {
            throw new RuntimeException(e);
        }

    }
}
