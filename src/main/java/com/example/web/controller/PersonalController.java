package com.example.web.controller;

import com.example.web.dao.model.User;
import com.example.web.dao.model.UserVoucher;
import com.example.web.service.UserVoucherService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet(name = "Personal", value = "/personal")
public class PersonalController extends HttpServlet {
    private final UserVoucherService userVoucherService = new UserVoucherService();
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect(req.getContextPath() + "/");
            return;
        }

        User user = (User) req.getSession().getAttribute("user");
        if (user != null) {
            try {
                List<UserVoucher> userVouchers = userVoucherService.getUnusedVouchersByUser(user.getId());
                req.setAttribute("userVouchers", userVouchers);
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        req.getRequestDispatcher("user/personal.jsp").forward(req, resp);
    }

}

