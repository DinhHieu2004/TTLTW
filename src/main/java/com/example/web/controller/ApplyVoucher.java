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
        String[] voucherIds = req.getParameterValues("vid");
        Cart cart = (Cart) req.getSession().getAttribute("cart");
        double totalPrice = cart.getTotalPrice();

        double finalDiscount = 0;

        if (voucherIds != null && voucherIds.length > 0) {
            for (String vid : voucherIds) {
                try {
                    Voucher voucher = voucherService.getVoucherById(vid);
                    if (voucher != null && voucher.isActive() && voucher.getEndDate().after(new Date())) {
                        finalDiscount += voucher.getDiscount(); // cộng dồn %
                    }
                } catch (SQLException e) {
                    throw new RuntimeException(e);
                }
            }
        }

        if (finalDiscount > 100) {
            finalDiscount = 100;
        }

        double finalPrice = totalPrice - (totalPrice * finalDiscount / 100);
        cart.setAfterPrice(finalPrice);
        req.getSession().setAttribute("cart", cart);

        resp.setContentType("application/json");
        resp.getWriter().write("{\"finalPrice\": " + finalPrice + "}");
    }

}
