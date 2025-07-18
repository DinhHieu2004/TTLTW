package com.example.web.controller.orderController;

import com.example.web.controller.util.GsonProvider;
import com.example.web.dao.model.Order;
import com.example.web.dao.model.User;
import com.example.web.service.OrderService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/user/orders")
public class GetOrderForUser extends HttpServlet {
    private final OrderService orderService = new OrderService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("user");
        int userId = user.getId();

        List<Order> currentOrders = null;
        List<Order> previousOrders = null;
        List<Order> allOrders;
        try {
            currentOrders = orderService.getCurrentOrdersForUser(userId);
            previousOrders = orderService.getHistoryOrder(userId);
            allOrders = new ArrayList<>();
            allOrders.addAll(currentOrders);
            allOrders.addAll(previousOrders);

        } catch (Exception e) {
            throw new RuntimeException(e);
        }

        Map<String, Object> result = new HashMap<>();
        result.put("currentOrders", currentOrders);
        result.put("previousOrders", previousOrders);
        result.put("orders", allOrders);

        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");
        resp.getWriter().write(GsonProvider.getGson().toJson(result));
    }
}
