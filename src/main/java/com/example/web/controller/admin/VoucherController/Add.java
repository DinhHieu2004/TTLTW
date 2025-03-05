package com.example.web.controller.admin.VoucherController;

import com.example.web.dao.model.Voucher;
import com.example.web.service.VoucherService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

@WebServlet("/admin/vouchers/add")
public class Add extends HttpServlet {
    private VoucherService voucherService = new VoucherService();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String name = req.getParameter("name");
        String isActives = req.getParameter("isActive");
        String discount = req.getParameter("discount");
        String startDate = req.getParameter("startDate");
        String endDate = req.getParameter("endDate");

        boolean isActive = isActives != null && isActives.equals("on");
        double dis = Double.parseDouble(discount);
        SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy");

        Voucher voucher = null;
        try {
            Date sd = sdf.parse(startDate);
            Date ed = sdf.parse(endDate);
            voucher = new Voucher(name,dis,isActive,sd, ed);

        } catch (ParseException e) {
            throw new RuntimeException(e);
        }
        try {
            boolean isUpdate = voucherService.addVoucher(voucher);
            if (isUpdate) {
                resp.sendRedirect("../vouchers");
            } else {
                resp.getWriter().write("{\"success\": false, \"message\": \"Them thất bại.\"}");
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }
}
