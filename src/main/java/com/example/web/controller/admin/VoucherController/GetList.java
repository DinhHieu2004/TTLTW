package com.example.web.controller.admin.VoucherController;

import com.example.web.controller.util.CheckPermission;
import com.example.web.dao.model.User;
import com.example.web.dao.model.Voucher;
import com.example.web.service.VoucherService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/admin/vouchers")
public class GetList extends HttpServlet {
    private VoucherService voucherService = new VoucherService();
    private final String permission = "VIEW_VOUCHERS";

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("user");

        boolean hasPermission = CheckPermission.checkPermission(user, permission, "ADMIN");
        if (!hasPermission) {
            resp.sendRedirect(req.getContextPath() + "/NoPermission.jsp");
            return;
        }
        try {
            List<Voucher> vs = voucherService.getAllAdmin();
            req.setAttribute("vs", vs);
            req.getRequestDispatcher("vouchers.jsp").forward(req, resp);
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }
}
