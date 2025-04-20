package com.example.web.controller;

import com.example.web.dao.model.User;
import com.example.web.service.UserVoucherService;
import com.example.web.service.VoucherService;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;

@WebServlet("/collect-voucher")
public class CollectVoucher extends HttpServlet {
    private final VoucherService voucherService = new VoucherService();
    private final UserVoucherService userVoucherService = new UserVoucherService();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            resp.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }

        try {
            voucherService.giveDefaultVoucherToUser(user.getId());
            resp.setStatus(HttpServletResponse.SC_OK);
        } catch (Exception e) {
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            resp.getWriter().write("Lỗi khi lưu voucher");
        }
    }
}
