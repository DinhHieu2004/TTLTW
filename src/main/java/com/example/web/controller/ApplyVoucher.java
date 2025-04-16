package com.example.web.controller;

import com.example.web.dao.cart.Cart;
import com.example.web.dao.model.Voucher;
import com.example.web.service.VoucherService;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.Date;
import java.sql.SQLException;

@WebServlet("/applyVoucher")
    public class ApplyVoucher extends HttpServlet {
    private final VoucherService voucherService = new VoucherService();
        @Override
        protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
            String vid = req.getParameter("vid");
            Cart cart = (Cart) req.getSession().getAttribute("cart");
            double totalPrice = cart.getTotalPrice();

            double discountPercentage = 0;
            if (vid != null && !vid.isEmpty()) {
                Voucher voucher = null;
                try {
                    voucher = voucherService.getVoucherById(vid);
                } catch (SQLException e) {
                    throw new RuntimeException(e);
                }
                if (voucher != null && voucher.isActive() && voucher.getEndDate().after(new Date())) {
                    discountPercentage = voucher.getDiscount();
                }
            }

            double finalPrice = totalPrice - (totalPrice * discountPercentage / 100);
            cart.setAfterPrice(finalPrice);
            req.getSession().setAttribute("cart", cart);


            resp.setContentType("application/json");
            resp.getWriter().write("{\"finalPrice\": " + finalPrice + "}");
        }
    }
