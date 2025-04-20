package com.example.web.controller.admin.discountController;

import com.example.web.controller.util.CheckPermission;
import com.example.web.dao.DiscountDao;
import com.example.web.dao.model.Discount;
import com.example.web.dao.model.User;
import com.example.web.service.DiscountService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/admin/discount")
public class ShowDiscount extends HttpServlet {

    private final String permission="VIEW_DISCOUNTS";
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        boolean hasPermission = CheckPermission.checkPermission(user, permission, "ADMIN");
        if (!hasPermission) {
            response.sendRedirect(request.getContextPath() + "/NoPermission.jsp");
            return;
        }

        DiscountService service = new DiscountService();

        List<Discount> list = null;

        try {
            list = service.getAllDiscount();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }

        request.setAttribute("list", list);
        request.getRequestDispatcher("/admin/discount.jsp").forward(request, response);
    }
}
