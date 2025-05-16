package com.example.web.controller;

import com.example.web.dao.model.BestSalePaiting;
import com.example.web.dao.model.Order;
import com.example.web.dao.model.Painting;
import com.example.web.dao.model.User;
import com.example.web.service.AdminService;
import com.example.web.service.OrderService;
import com.example.web.service.PaintingService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.cloudinary.json.JSONObject;

import java.io.IOException;
import java.io.PrintWriter;
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

        HttpSession session = request.getSession();

        User user = (User) session.getAttribute("user");
        System.out.println(" user permission at admin: "+ user.getAllRolePermission());


        if (path == null || path.equals("/")) {
            double totalRevenue = 0;
            int totalOrders = 0;
            int totalUsers = 0;
            int totalProducts = 0;
            Map<String, Integer> orderStatusCount = null;
            Map<String, Double> revenueByArtist = null;
            List<Map<String, Object>> listRating = null;
            List<BestSalePaiting> best = null;

            String startDate = request.getParameter("startDate");
            String endDate = request.getParameter("endDate");

            try {
                totalRevenue = adminService.getTotalRevenue(startDate, endDate);
                totalOrders = adminService.getTotalOrders(startDate, endDate);
                totalUsers = adminService.getTotalUsers();
                totalProducts = adminService.getTotalProducts();
                revenueByArtist = adminService.getRevenueByArtist(startDate, endDate);
                orderStatusCount = adminService.getOrderStatusCount(startDate, endDate);
                listRating = adminService.getAverageRatings(startDate, endDate);
                best = adminService.getBestSalePaiting(startDate, endDate);
            } catch (SQLException e) {
                throw new RuntimeException(e);
            }

            if ("XMLHttpRequest".equals(request.getHeader("X-Requested-With"))) {
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");

                JSONObject json = new JSONObject();
                json.put("totalRevenue", totalRevenue);
                json.put("totalOrders", totalOrders);
                json.put("totalUsers", totalUsers);
                json.put("totalProducts", totalProducts);
                json.put("revenueByArtist", revenueByArtist);
                json.put("orderStatusCount", orderStatusCount);
                json.put("listRating", listRating);
                json.put("best", best);

                PrintWriter out = response.getWriter();
                out.print(json.toString());
                out.flush();
            } else {
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

}
