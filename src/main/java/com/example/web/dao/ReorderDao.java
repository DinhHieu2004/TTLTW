package com.example.web.dao;



import com.example.web.dao.db.DbConnect;
import com.example.web.dao.model.ReorderAlert;
import com.example.web.dao.model.SlowSellingProduct;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ReorderDao {
    Connection conn = DbConnect.getConnection();

    public  List<ReorderAlert> getReorderAlerts() throws SQLException {
        List<ReorderAlert> alerts = new ArrayList<>();

        String sql = """
            SELECT 
                p.id AS paintingId,
                p.title,
                sz.id AS sizeId,
                sz.sizeDescription,
                (ps.totalQuantity - ps.reservedQuantity) AS avaiQuantity,
                COALESCE(SUM(oi.quantity), 0) / 30.0 AS avgDailySale,
                (COALESCE(SUM(oi.quantity), 0) / 30.0) * 7 AS reorderThreshold
            FROM painting_sizes ps
            JOIN paintings p ON ps.paintingId = p.id
            JOIN sizes sz ON ps.sizeId = sz.id
            LEFT JOIN order_items oi ON oi.paintingId = ps.paintingId AND oi.sizeId = ps.sizeId
            LEFT JOIN orders o ON oi.orderId = o.id AND o.orderDate >= DATE_SUB(CURDATE(), INTERVAL 30 DAY) AND o.deliveryStatus = 'Hoàn thành'
            GROUP BY ps.paintingId, ps.sizeId
            HAVING avaiQuantity < reorderThreshold
            ORDER BY reorderThreshold DESC
        """;
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                ReorderAlert alert = new ReorderAlert();
                alert.setPaintingId(rs.getInt("paintingId"));
                alert.setTitle(rs.getString("title"));
                alert.setSizeId(rs.getInt("sizeId"));
                alert.setSizeDescription(rs.getString("sizeDescription"));
                alert.setDisplayQuantity(rs.getInt("avaiQuantity"));
                alert.setAvgDailySale(Math.ceil(rs.getDouble("avgDailySale")));
                alert.setReorderThreshold(Math.ceil(rs.getDouble("reorderThreshold")));
                alerts.add(alert);
            }

        return alerts;
    }

    public List<SlowSellingProduct> getSlowSellingProducts() throws SQLException {
        List<SlowSellingProduct> products = new ArrayList<>();

        String sql = """
        SELECT 
            p.id AS paintingId,
            p.title,
            sz.id AS sizeId,
            sz.sizeDescription,
            ps.displayQuantity,
            COALESCE(SUM(oi.quantity), 0) / 30.0 AS avgDailySale
        FROM painting_sizes ps
        JOIN paintings p ON ps.paintingId = p.id
        JOIN sizes sz ON ps.sizeId = sz.id
        LEFT JOIN order_items oi ON oi.paintingId = ps.paintingId AND oi.sizeId = ps.sizeId
        LEFT JOIN orders o ON oi.orderId = o.id
            AND o.orderDate >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)

            AND o.status = 'hoàn thành'

        GROUP BY ps.paintingId, ps.sizeId
        HAVING avgDailySale < 0.3
        ORDER BY avgDailySale ASC
    """;

        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                SlowSellingProduct product = new SlowSellingProduct();
                product.setPaintingId(rs.getInt("paintingId"));
                product.setTitle(rs.getString("title"));
                product.setSizeId(rs.getInt("sizeId"));
                product.setSizeDescription(rs.getString("sizeDescription"));
                product.setDisplayQuantity(rs.getInt("displayQuantity"));
                product.setAvgDailySale(rs.getDouble("avgDailySale"));

                products.add(product);
            }
        }

        return products;
    }


    public static void main(String[] args) throws SQLException {
        ReorderDao reorderDao = new ReorderDao();
        System.out.println(reorderDao.getSlowSellingProducts());
    }
}
