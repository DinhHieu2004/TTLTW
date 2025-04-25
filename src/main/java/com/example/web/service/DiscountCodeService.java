package com.example.web.service;


import com.example.web.dao.DiscountCodeDao;
import com.example.web.dao.model.DiscountCode;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.List;

public class DiscountCodeService {
    private DiscountCodeDao discountCodeDao = new DiscountCodeDao();


    // Lấy mã giảm giá đang hoạt động theo thời gian
    public List<DiscountCode> getActiveTimeBasedCodes() throws SQLException {
        return discountCodeDao.getActiveTimeBasedCodes();
    }

    // Thêm mã giảm giá cho đơn hàng thành công
    public DiscountCode generateOrderSuccessDiscount() throws SQLException {
        String code = generateRandomCode(8);
        DiscountCode newCode = new DiscountCode();
        newCode.setCode(code);
        newCode.setDescription("Cảm ơn bạn đã đặt hàng!");
        newCode.setDiscountPercent(10);
        newCode.setTriggerEvent("ORDER_SUCCESS");
        newCode.setActive(true);

        discountCodeDao.insertDiscountCode(newCode);
        return newCode;
    }

    // Hàm tạo mã ngẫu nhiên
    private String generateRandomCode(int length) {
        String chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
        StringBuilder code = new StringBuilder();
        for (int i = 0; i < length; i++) {
            int rand = (int) (Math.random() * chars.length());
            code.append(chars.charAt(rand));
        }
        return code.toString();
    }
}

