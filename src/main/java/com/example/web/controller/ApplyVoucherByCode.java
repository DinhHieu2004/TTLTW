package com.example.web.controller;

import com.example.web.dao.cart.Cart;
import com.example.web.dao.model.Voucher;
import com.example.web.service.VoucherService;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.util.Date;

@WebServlet("/applyVoucherByCode")
public class ApplyVoucherByCode extends HttpServlet {
    private final VoucherService voucherService = new VoucherService();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        Cart cart = (Cart) session.getAttribute("cart");
        double totalPrice = cart.getTotalPrice();
        Double shippingFee = (Double) session.getAttribute("shippingFee");

        String code = req.getParameter("code");
        Voucher voucher = null;

        try {
            voucher = voucherService.getVoucherByCode(code);
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }

        resp.setContentType("application/json");
        PrintWriter out = resp.getWriter();

        if (voucher != null && voucher.isActive() && voucher.getEndDate().after(new Date())) {
            String type = voucher.getType(); // "order" hoặc "shipping"
            double discount = voucher.getDiscount();

            StringBuilder json = new StringBuilder();
            json.append("{\"success\": true, ");

            if ("order".equalsIgnoreCase(type)) {
                double finalPrice = totalPrice - (totalPrice * discount / 100);
                cart.setAfterPrice(finalPrice);
                session.setAttribute("cart", cart);
                json.append("\"finalPrice\": ").append(finalPrice).append(", ");
            } else if ("shipping".equalsIgnoreCase(type)) {
                if (shippingFee != null) {
                    double discountedShippingFee = shippingFee - (shippingFee * discount / 100);
                    session.setAttribute("shippingFeeAfterVoucher", discountedShippingFee);
                    json.append("\"shippingFee\": ").append(discountedShippingFee).append(", ");
                }
            }

            json.append("\"voucherId\": \"").append(voucher.getId()).append("\"}");
            out.write(json.toString());
        } else {
            out.write("{\"success\": false}");
        }
    }
}
