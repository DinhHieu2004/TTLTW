package com.example.web.controller;

import com.example.web.dao.model.BestSalePaiting;
import com.example.web.dao.model.Order;
import com.example.web.dao.model.Painting;
import com.example.web.service.AdminService;
import com.example.web.service.OrderService;
import com.example.web.service.PaintingService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;

@WebServlet("/admin/")
public class AdminServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getPathInfo();
        AdminService adminService = new AdminService();

        if (path == null || path.equals("/")) {
            double totalRevenue = 0;
            int totalOrders = 0;
            int totalUsers = 0;
            int totalProducts = 0;
            Map<String, Integer> orderStatusCount = null;
            Map<String, Double> revenueByArtist = null;
            List<Map<String, Object>> listRating = null;
            List<BestSalePaiting> best = null;

            try {
                totalRevenue = adminService.getTotalRevenue();
                totalOrders = adminService.getTotalOrders();
                totalUsers = adminService.getTotalUsers();
                totalProducts = adminService.getTotalProducts();
                revenueByArtist = adminService.getRevenueByArtist();
                orderStatusCount = adminService.getOrderStatusCount();
                listRating = adminService.getAverageRatings();
                best = adminService.getBestSalePaiting();

            } catch (SQLException e) {
                throw new RuntimeException(e);
            }


            request.setAttribute("totalRevenue", totalRevenue);
            request.setAttribute("totalOrders", totalOrders);
            request.setAttribute("totalUsers", totalUsers);
            request.setAttribute("totalProducts", totalProducts);
            request.setAttribute("revenueByArtist", revenueByArtist);
            request.setAttribute("orderStatusCount", orderStatusCount);
            request.setAttribute("listRating", listRating);
            request.setAttribute("best", best);

            request.getRequestDispatcher("admin.jsp").forward(request, response);
        }
    }

}
