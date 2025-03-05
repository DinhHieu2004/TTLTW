package com.example.web.controller.admin.VoucherController;


import com.example.web.controller.util.GsonProvider;
import com.example.web.dao.model.Artist;
import com.example.web.dao.model.Voucher;
import com.example.web.service.ArtistService;
import com.example.web.service.VoucherService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/admin/vouchers/detail")
public class GetDetail extends HttpServlet {
    private VoucherService voucherService = new VoucherService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String vid = req.getParameter("vid");

        try {
            Voucher v = voucherService.getVoucherById(vid);
            resp.setContentType("application/json");
            resp.setCharacterEncoding("UTF-8");
            resp.getWriter().write(GsonProvider.getGson().toJson(v));
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

}
