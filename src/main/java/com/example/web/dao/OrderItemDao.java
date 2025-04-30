package com.example.web.dao;
import com.example.web.dao.db.DbConnect;
import com.example.web.dao.model.OrderItem;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class OrderItemDao {
    private Connection conn = DbConnect.getConnection();
    public void addOrderItem(OrderItem orderItem) throws Exception {
        String sql = "INSERT INTO order_items (orderId, paintingId, sizeId,quantity , price) VALUES (?, ?, ?, ?, ?)";
        PreparedStatement ps = conn.prepareStatement(sql) ;
        ps.setInt(1, orderItem.getOrderId());
        ps.setInt(2, orderItem.getPaintingId());
        ps.setInt(3, orderItem.getSizeId());
        ps.setInt(4, orderItem.getQuantity());
        ps.setDouble(5, orderItem.getPrice());
        ps.executeUpdate();

    }
    public List<OrderItem> getListOrderItem(int orderId) throws SQLException {
        String sql = """
                    SELECT oi.orderId, oi.paintingId, p.title AS productName,  p.imageUrl, p.imageUrlCloud, s.sizeDescription AS sizeDescription, 
                           oi.sizeId, oi.quantity, oi.price , oi.id
                    FROM order_items oi
                    JOIN paintings p ON oi.paintingId = p.id
                    JOIN sizes s ON oi.sizeId = s.id
                    WHERE oi.orderId = ?
                """;
        List<OrderItem> orderItems = new ArrayList<OrderItem>();
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setInt(1, orderId);
        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
            OrderItem orderItem = new OrderItem();
            orderItem.setId(rs.getInt("id"));
            orderItem.setName(rs.getString("productName"));
            orderItem.setImg(rs.getString("imageUrl"));
            orderItem.setImageUrlCloud(rs.getString("imageUrlCloud"));
            orderItem.setOrderId(rs.getInt("orderId"));
            orderItem.setPaintingId(rs.getInt("paintingId"));
            orderItem.setSizeId(rs.getInt("sizeId"));
            orderItem.setQuantity(rs.getInt("quantity"));
            orderItem.setPrice(rs.getDouble("price"));
            orderItem.setSizeDescription(rs.getString("sizeDescription"));
            orderItems.add(orderItem);
        }
        return orderItems;
    }

    public static void main(String[] args) throws SQLException {
        OrderItemDao orderItemDao = new OrderItemDao();
        for(OrderItem o : orderItemDao.getListOrderItem(37)){
            System.out.println(o);
        }
    }

}