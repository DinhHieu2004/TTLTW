package com.example.web.controller.admin.OrderController;

import com.example.web.controller.util.CheckPermission;
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
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/admin/orders")

public class ShowOrder extends HttpServlet {
    OrderService orderService = new OrderService();
    private final String permission = "VIEW_ORDERS";

    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("user");

        boolean hasPermission = CheckPermission.checkPermission(user, permission, "ADMIN");
        if (!hasPermission) {
            resp.sendRedirect(req.getContextPath() + "/NoPermission.jsp");
            return;
        }

        try {
            List<Order> currentOrder = orderService.getOrderCurrentAdmin();
            List<Order> historyOrder = orderService.getOrderHistoryAdmin();

            List<Order> ordersD = orderService.getOrdersDeleted();

            req.setAttribute("currentOrder",currentOrder);
            req.setAttribute("historyOrder",historyOrder);

            req.setAttribute("ordersD",ordersD);

            req.getRequestDispatcher("orders.jsp").forward(req, resp);

        } catch (Exception e) {
            throw new RuntimeException(e);
        }

    }
}
