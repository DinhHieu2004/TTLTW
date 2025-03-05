package com.example.web.controller.OrderItemController;
import com.example.web.controller.util.GsonProvider;
import com.example.web.dao.model.Order;
import com.example.web.service.OrderService;
import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet(name=" OrderDetail", value = "/order-detail")
public class DetailOrder extends HttpServlet {
    private OrderService orderService;
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");

        String orderIdParam = req.getParameter("orderId");
        System.out.println(orderIdParam);
        int orderId = Integer.parseInt(orderIdParam);
        orderService = new OrderService();

        try {
            Order order = orderService.getOrder(orderId);

            if (order == null) {
                resp.setStatus(HttpServletResponse.SC_NOT_FOUND);
                resp.getWriter().write("{\"error\": \"No items found for this order\"}");
                return;
            }
            System.out.println(order);
            resp.getWriter().write(GsonProvider.getGson().toJson(order));
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }
}
