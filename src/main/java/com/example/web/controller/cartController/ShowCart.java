package com.example.web.controller.cartController;

import com.example.web.dao.cart.Cart;
import com.example.web.dao.model.PaymentMethod;
import com.example.web.service.PaymentMethodService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet(name = "ShowCart", value = "/show-cart")
public class ShowCart extends HttpServlet {
    private PaymentMethodService paymentMethodService = new PaymentMethodService();
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            HttpSession session = req.getSession();

            List<PaymentMethod> paymentMethods = paymentMethodService.getAllPaymentMethods();
            req.setAttribute("paymentMethods", paymentMethods);
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        req.getRequestDispatcher("user/shopping-cart.jsp").forward(req, resp);
    }
}
