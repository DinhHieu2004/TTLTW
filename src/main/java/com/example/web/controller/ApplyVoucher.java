package com.example.web.controller;

import com.example.web.dao.cart.Cart;
import com.example.web.dao.model.Voucher;
import com.example.web.service.VoucherService;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.Date;
import java.sql.SQLException;

@WebServlet("/applyVoucher")
public class ApplyVoucher extends HttpServlet {
    private final VoucherService voucherService = new VoucherService();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String[] voucherIds = req.getParameterValues("vid");
        HttpSession session = req.getSession();
        Cart cart = (Cart) session.getAttribute("cart");

        double totalPrice = cart.getTotalPrice();
        Double shippingFee = (Double) session.getAttribute("shippingFee");

        double orderDiscountPercent = 0;
        double shippingDiscountPercent = 0;

        if (voucherIds != null) {
            for (String vid : voucherIds) {
                try {
                    Voucher voucher = voucherService.getVoucherById(vid);
                    if (voucher != null && voucher.isActive() && voucher.getEndDate().after(new Date())) {
                        String type = voucher.getType(); // "order" hoặc "shipping"
                        double discount = voucher.getDiscount();

                        if ("order".equalsIgnoreCase(type)) {
                            orderDiscountPercent += discount;
                        } else if ("shipping".equalsIgnoreCase(type)) {
                            shippingDiscountPercent += discount;
                        }
                    }
                } catch (SQLException e) {
                    throw new RuntimeException(e);
                }
            }
        }

        if (orderDiscountPercent > 100) orderDiscountPercent = 100;
        if (shippingDiscountPercent > 100) shippingDiscountPercent = 100;

        // giảm giá đơn hàng
        double finalPrice;
        if (orderDiscountPercent > 0) {
            finalPrice = totalPrice - (totalPrice * orderDiscountPercent / 100);
        } else {
            finalPrice = totalPrice;
        }
        cart.setAfterPrice(finalPrice);
        session.setAttribute("cart", cart);


        // phí giao hàng sau khi áp dụng giảm nếu có
        double discountedShippingFee = -1;
        if (shippingFee != null) {
            discountedShippingFee = (shippingDiscountPercent > 0)
                    ? shippingFee - (shippingFee * shippingDiscountPercent / 100)
                    : shippingFee;

            session.setAttribute("shippingFeeAfterVoucher", discountedShippingFee);
        }

        resp.setContentType("application/json");
        PrintWriter out = resp.getWriter();
        StringBuilder json = new StringBuilder();
        json.append("{");

        json.append("\"finalPrice\":").append(finalPrice);

        if (shippingFee != null) {
            json.append(", \"shippingFee\":").append(discountedShippingFee);
        }

        json.append("}");
        out.write(json.toString());
    }
}

