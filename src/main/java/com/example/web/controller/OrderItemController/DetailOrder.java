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
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/order-detail")
public class DetailOrder extends HttpServlet {
    private final OrderService orderService = new OrderService();
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");

        String orderIdParam = req.getParameter("orderId");
        int orderId = Integer.parseInt(orderIdParam);

        try {
            Order order = orderService.getOrder(orderId);

            if (order == null) {
                resp.setStatus(HttpServletResponse.SC_NOT_FOUND);
                resp.getWriter().write("{\"error\": \"No items found for this order\"}");
                return;
            }

            // Phân tách các id voucher trong order
            List<String> appliedVoucherNames = new ArrayList<>();
            if(order.getAppliedVoucherIds() != null && !order.getAppliedVoucherIds().isEmpty()) {
                String[] voucherIdArray = order.getAppliedVoucherIds().split(",");
                appliedVoucherNames = orderService.getVoucherNamesByIds(voucherIdArray);
            }

            Map<String, Object> response = new HashMap<>();
            response.put("order", order);
            response.put("appliedVouchers", appliedVoucherNames);
            resp.setContentType("application/json");
            resp.getWriter().write(GsonProvider.getGson().toJson(response));
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }
}
