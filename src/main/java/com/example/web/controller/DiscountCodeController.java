package com.example.web.controller;

import com.example.web.dao.model.DiscountCode;
import com.example.web.service.DiscountCodeService;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.util.List;

@WebServlet("/discountCode")
public class DiscountCodeController extends HttpServlet {
    private final DiscountCodeService discountCodeService;

    public DiscountCodeController(DiscountCodeService discountCodeService) {
        this.discountCodeService = discountCodeService;
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            // Lấy danh sách mã giảm giá theo thời gian
            List<DiscountCode> timeBasedCodes = discountCodeService.getActiveTimeBasedCodes();

            // Gửi danh sách sang JSP
            request.setAttribute("timeBasedDiscounts", timeBasedCodes);
            request.getRequestDispatcher("discount.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(500, "Lỗi khi lấy mã giảm giá.");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }
}