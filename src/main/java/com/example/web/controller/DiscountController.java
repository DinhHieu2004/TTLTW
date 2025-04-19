package com.example.web.controller;


import com.example.web.dao.DiscountDao;
import com.example.web.dao.PaintingDao;
import com.example.web.dao.model.Discount;
import com.example.web.dao.model.Painting;
import com.example.web.dao.model.Theme;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/discount")
public class DiscountController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        DiscountDao discountDao = new DiscountDao();

        List<Discount> validDiscount = new ArrayList<>();
        List<Discount> list;
        try {
            list = discountDao.getAllDiscount();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        ;
        LocalDate today = LocalDate.now();
        for (Discount discount : list) {
            LocalDate endDate = discount.getEndDate();

            if(!endDate.plusDays(2).isBefore(today)) {
                validDiscount.add(discount);
            }
        }

        request.setAttribute("list", validDiscount);

        request.getRequestDispatcher("/user/discount.jsp").forward(request, response);

    }
}