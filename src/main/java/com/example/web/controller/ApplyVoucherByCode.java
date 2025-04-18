package com.example.web.controller;

import com.example.web.dao.cart.Cart;
import com.example.web.dao.model.Voucher;
import com.example.web.service.VoucherService;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.sql.SQLException;
import java.util.Date;

@WebServlet("/applyVoucherByCode")
public class ApplyVoucherByCode extends HttpServlet {
    private final VoucherService voucherService = new VoucherService();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Cart cart = (Cart) req.getSession().getAttribute("cart");
        double totalPrice = cart.getTotalPrice();
        String code = req.getParameter("code");
        Voucher voucher = null;
        try {
            voucher = voucherService.getVoucherByCode(code);
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }

        if (voucher != null && voucher.isActive() && voucher.getEndDate().after(new Date())) {
            double discount = voucher.getDiscount();
            double finalPrice = totalPrice - (totalPrice * discount / 100);

            cart.setAfterPrice(finalPrice);
            req.getSession().setAttribute("cart", cart);

            resp.setContentType("application/json");
            resp.getWriter().write("{\"success\": true, \"finalPrice\": " + finalPrice + ", \"voucherId\": \"" + voucher.getId() + "\"}");
        } else {
            resp.setContentType("application/json");
            resp.getWriter().write("{\"success\": false}");
        }

    }
}