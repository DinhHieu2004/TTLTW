package com.example.web.dao;

import com.example.web.dao.db.DbConnect;
import com.example.web.dao.model.BestSalePaiting;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class AdminDao {
    private Connection conn = DbConnect.getConnection();

    public double getTotalRevenue(String startDate, String endDate) throws SQLException {
        double totalRevenue = 0;
        StringBuilder query = new StringBuilder("SELECT SUM(totalAmount) AS totalRevenue FROM orders WHERE deliveryStatus = 'hoàn thành'");

        if (startDate != null && endDate != null && !startDate.isEmpty() && !endDate.isEmpty()) {
            query.append(" AND orderDate BETWEEN ? AND ?");
        }

        PreparedStatement statement = conn.prepareStatement(query.toString());
        if (startDate != null && endDate != null && !startDate.isEmpty() && !endDate.isEmpty()) {
            statement.setString(1, startDate);
            statement.setString(2, endDate);
        }

        ResultSet resultSet = statement.executeQuery();
        if (resultSet.next()) {
            totalRevenue = resultSet.getDouble("totalRevenue");
        }

        return totalRevenue;
    }

    public int getTotalOrders(String startDate, String endDate) throws SQLException {
        int totalOrders = 0;
        StringBuilder query = new StringBuilder("SELECT COUNT(*) AS totalOrders FROM orders");

        if (startDate != null && endDate != null && !startDate.isEmpty() && !endDate.isEmpty()) {
            query.append(" WHERE orderDate BETWEEN ? AND ?");
        }

        PreparedStatement statement = conn.prepareStatement(query.toString());
        if (startDate != null && endDate != null && !startDate.isEmpty() && !endDate.isEmpty()) {
            statement.setString(1, startDate);
            statement.setString(2, endDate);
        }

        ResultSet resultSet = statement.executeQuery();
        if (resultSet.next()) {
            totalOrders = resultSet.getInt("totalOrders");
        }

        return totalOrders;
    }

    public int getTotalProducts() throws SQLException {
        int totalProducts = 0;
        String query = "SELECT COUNT(*) AS totalProducts FROM paintings";

        PreparedStatement statement = conn.prepareStatement(query);
        ResultSet resultSet = statement.executeQuery();

        if (resultSet.next()) {
            totalProducts = resultSet.getInt("totalProducts");
        }

        return (int) (totalProducts * 1.5);
    }

    public int getTotalUsers() throws SQLException {
        int totalUsers = 0;
        String query = "SELECT COUNT(*) AS totalUsers FROM users";

        PreparedStatement statement = conn.prepareStatement(query);
        ResultSet resultSet = statement.executeQuery();

        if (resultSet.next()) {
            totalUsers = resultSet.getInt("totalUsers");
        }

        return totalUsers;
    }

    public Map<String, Integer> getOrderStatusCount(String startDate, String endDate) throws SQLException {
        Map<String, Integer> orderStatusCount = new HashMap<>();
        StringBuilder query = new StringBuilder("SELECT deliveryStatus, COUNT(*) AS count FROM orders");

        if (startDate != null && endDate != null && !startDate.isEmpty() && !endDate.isEmpty()) {
            query.append(" WHERE orderDate BETWEEN ? AND ?");
        }
        query.append(" GROUP BY deliveryStatus");

        PreparedStatement statement = conn.prepareStatement(query.toString());
        if (startDate != null && endDate != null && !startDate.isEmpty() && !endDate.isEmpty()) {
            statement.setString(1, startDate);
            statement.setString(2, endDate);
        }

        ResultSet resultSet = statement.executeQuery();
        while (resultSet.next()) {
            String status = resultSet.getString("deliveryStatus");
            int count = resultSet.getInt("count");
            orderStatusCount.put(status, count);
        }

        return orderStatusCount;
    }

    public Map<String, Double> getArtistRevenueMap(String startDate, String endDate) throws SQLException {
        Map<String, Double> revenueMap = new HashMap<>();

        StringBuilder sql = new StringBuilder("""
        SELECT 
            a.name AS artist_name,
            COALESCE(SUM(oi.price * oi.quantity), 0) AS total_revenue
        FROM 
            artists a
            LEFT JOIN paintings p ON a.id = p.artistId
            LEFT JOIN order_items oi ON p.id = oi.paintingId
            LEFT JOIN orders o ON oi.orderId = o.id
        WHERE o.deliveryStatus = 'hoàn thành'
    """);

        // Kiểm tra điều kiện ngày
        boolean hasStartDate = startDate != null && !startDate.isEmpty();
        boolean hasEndDate = endDate != null && !endDate.isEmpty();

        if (hasStartDate && hasEndDate) {
            sql.append(" AND o.orderDate BETWEEN ? AND ? ");
        } else if (hasStartDate) {
            sql.append(" AND o.orderDate >= ? ");
        } else if (hasEndDate) {
            sql.append(" AND o.orderDate <= ? ");
        }

        sql.append("GROUP BY a.name ORDER BY total_revenue DESC");

        PreparedStatement stmt = conn.prepareStatement(sql.toString());

        int paramIndex = 1;
        if (hasStartDate) {
            stmt.setString(paramIndex++, startDate);
        }
        if (hasEndDate) {
            stmt.setString(paramIndex++, endDate);
        }

        ResultSet rs = stmt.executeQuery();
        while (rs.next()) {
            String artistName = rs.getString("artist_name");
            double revenue = rs.getDouble("total_revenue");
            revenueMap.put(artistName, revenue);
        }

        return revenueMap;
    }


    public List<Map<String, Object>> getAverageRatings(String startDate, String endDate) throws SQLException {
        List<Map<String, Object>> averageRatings = new ArrayList<>();

        StringBuilder query = new StringBuilder("SELECT rating, COUNT(*) as count FROM product_reviews");

        boolean hasValidDates = startDate != null && endDate != null &&
                !startDate.trim().isEmpty() && !endDate.trim().isEmpty();

        if (hasValidDates) {
            query.append(" WHERE createdAt BETWEEN ? AND ?");
        }

        query.append(" GROUP BY rating");

        System.out.println("DEBUG - SQL Query: " + query.toString());

        try (PreparedStatement stmt = conn.prepareStatement(query.toString())) {
            if (hasValidDates) {
                stmt.setString(1, startDate);
                stmt.setString(2, endDate);
            }

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> ratingData = new HashMap<>();
                    ratingData.put("rating", rs.getInt("rating"));
                    ratingData.put("count", rs.getInt("count"));
                    averageRatings.add(ratingData);
                }
            }
        }

        return averageRatings;
    }


    public List<BestSalePaiting> getBestSellingPaintings(String startDate, String endDate) throws SQLException {
        StringBuilder sql = new StringBuilder("""
            SELECT p.title, SUM(oi.quantity) AS totalSold
            FROM order_items oi
            JOIN paintings p ON oi.paintingId = p.id
            JOIN orders o ON oi.orderId = o.id AND o.deliveryStatus = 'hoàn thành'
        """);

        if (startDate != null && endDate != null && !startDate.isEmpty() && !endDate.isEmpty()) {
            sql.append(" WHERE o.orderDate BETWEEN ? AND ?");
        }
        sql.append(" GROUP BY p.id, p.title ORDER BY totalSold DESC LIMIT 5");

        List<BestSalePaiting> bestSellingPaintings = new ArrayList<>();
        PreparedStatement stmt = conn.prepareStatement(sql.toString());
        if (startDate != null && endDate != null && !startDate.isEmpty() && !endDate.isEmpty()) {
            stmt.setString(1, startDate);
            stmt.setString(2, endDate);
        }

        ResultSet rs = stmt.executeQuery();
        while (rs.next()) {
            String title = rs.getString("title");
            int totalSold = rs.getInt("totalSold");
            bestSellingPaintings.add(new BestSalePaiting(title, totalSold));
        }

        return bestSellingPaintings;
    }

    public static void main(String[] args) throws SQLException {
        AdminDao adminDao = new AdminDao();
        System.out.println(adminDao.getBestSellingPaintings("2025-05-01 05:13:22","2025-05-16 05:13:22"));
    }
}