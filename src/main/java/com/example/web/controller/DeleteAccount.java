package com.example.web.controller;

import com.example.web.dao.model.Order;
import com.example.web.dao.model.User;
import com.example.web.service.AuthService;
import com.example.web.service.OrderService;
import com.example.web.service.UserService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;


@WebServlet("/delete-customer-account")
public class DeleteAccount extends HttpServlet {
    private AuthService authService = new AuthService();
    private UserService userService = new UserService();
    private OrderService orderService = new OrderService();
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("application/json");
        PrintWriter out = resp.getWriter();
        HttpSession session = req.getSession(false);

        User currentUser = (session != null) ? (User) session.getAttribute("user") : null;

        if (currentUser == null) {
            resp.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            out.print("{\"error\": \"Bạn chưa đăng nhập.\"}");
            return;
        }

        try {
            List<Order> currentOrders = orderService.getCurrentOrdersForUser(currentUser.getId());
            boolean hasOrders = currentOrders != null && !currentOrders.isEmpty();
            if (hasOrders) {
                resp.setStatus(HttpServletResponse.SC_CONFLICT);
                out.print("{\"error\": \"Tài khoản có đơn hàng đang xử lý. Không thể xóa.\"}");
                return;
            }

            boolean marked = authService.deleteAndSendUndoMail(currentUser);;
            if (marked) {
                session.invalidate();
            } else {
                resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                out.print("{\"error\": \"Không thể xử lý yêu cầu xóa tài khoản.\"}");
            }

        } catch (Exception e) {
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"error\": \"Lỗi server: " + e.getMessage() + "\"}");
        }
    }
}
