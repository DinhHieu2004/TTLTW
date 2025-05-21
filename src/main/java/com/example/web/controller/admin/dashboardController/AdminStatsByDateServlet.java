package com.example.web.controller.admin.dashboardController;

import com.example.web.dao.model.BestSalePaiting;
import com.example.web.service.AdminService;
import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;

@WebServlet("/admin/stats-by-date")
public class AdminStatsByDateServlet extends HttpServlet {

    private final AdminService adminService = new AdminService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try {
            double totalRevenue = adminService.getTotalRevenue(startDate, endDate);
            int totalOrders = adminService.getTotalOrders(startDate, endDate);
            int totalUsers = adminService.getTotalUsers();
            int totalProducts = adminService.getTotalProducts();
            Map<String, Double> revenueByArtist = adminService.getRevenueByArtist(startDate, endDate);
            Map<String, Integer> orderStatusCount = adminService.getOrderStatusCount(startDate, endDate);
            List<Map<String, Object>> listRating = adminService.getAverageRatings(startDate, endDate);
            List<BestSalePaiting> best = adminService.getBestSalePaiting(startDate, endDate);

            FullStatsResponse stats = new FullStatsResponse(
                    totalRevenue, totalOrders, totalUsers, totalProducts,
                    revenueByArtist, orderStatusCount, listRating, best
            );

            Gson gson = new Gson();
            String json = gson.toJson(stats);
            response.getWriter().write(json);

        } catch (SQLException e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\": \"Database error.\"}");
        }
    }

    static class FullStatsResponse {
        double totalRevenue;
        int totalOrders;
        int totalUsers;
        int totalProducts;
        Map<String, Double> revenueByArtist;
        Map<String, Integer> orderStatusCount;
        List<Map<String, Object>> listRating;
        List<BestSalePaiting> best;

        public FullStatsResponse(double totalRevenue, int totalOrders, int totalUsers, int totalProducts,
                                 Map<String, Double> revenueByArtist, Map<String, Integer> orderStatusCount,
                                 List<Map<String, Object>> listRating, List<BestSalePaiting> best) {
            this.totalRevenue = totalRevenue;
            this.totalOrders = totalOrders;
            this.totalUsers = totalUsers;
            this.totalProducts = totalProducts;
            this.revenueByArtist = revenueByArtist;
            this.orderStatusCount = orderStatusCount;
            this.listRating = listRating;
            this.best = best;
        }
    }
}
