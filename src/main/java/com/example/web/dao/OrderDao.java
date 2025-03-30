package com.example.web.dao;

import com.example.web.dao.db.DbConnect;
import com.example.web.dao.model.Order;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class OrderDao {
    private Connection conn = DbConnect.getConnection();
    public int createOrder(Order order) throws Exception {
        String sql = "INSERT INTO orders (userId, totalAmount, status, deliveryDate, recipientName, deliveryAddress, recipientPhone, paymentMethod) VALUES (?, ?, ?, ?, ?, ?,?,?)";
        PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
        ps.setInt(1, order.getUserId());
        ps.setDouble(2, order.getTotalAmount());
        ps.setString(3, order.getStatus());
        ps.setDate(4, order.getDeliveryDate() != null ? (Date) order.getDeliveryDate() : null);
        ps.setString(5, order.getRecipientName());
        ps.setString(6, order.getDeliveryAddress());
        ps.setString(7, order.getRecipientPhone());
        ps.setString(8, order.getPaymentMethod());

        ps.executeUpdate();
        try (ResultSet rs = ps.getGeneratedKeys()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        throw new Exception("Unable to create order");
    }
    public List<Order> getCurrentOrdersForUser(int userId) throws Exception {
        List<Order> orders = new ArrayList<>();
        String query = "SELECT * FROM orders WHERE userId = ? AND status IN ('chờ', 'đang giao') ORDER BY orderDate DESC";

        PreparedStatement ps = conn.prepareStatement(query);
            ps.setInt(1, userId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Order order = extractOrderFromResultSet(rs);
                    orders.add(order);
                }
            }
        return orders;
    }
    public List<Order> getHistoryOrder(int userId) throws Exception {
        List<Order> orders = new ArrayList<>();
        String query = "SELECT * FROM orders WHERE userId = ? AND status IN ('hoàn thành', 'thất bại','đã hủy') ORDER BY orderDate DESC";

        PreparedStatement ps = conn.prepareStatement(query);
        ps.setInt(1, userId);

        try (ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Order order = extractOrderFromResultSet(rs);
                orders.add(order);
            }
        }
        return orders;
    }
    public Order getOrder(int orderId) throws Exception {
        String sql = "SELECT * FROM orders WHERE id = ?";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setInt(1, orderId);
        try (ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return extractOrderFromResultSet(rs);
            }
        }
        return null;
    }
    private Order extractOrderFromResultSet(ResultSet rs) throws Exception {
        Order order = new Order();
        order.setId(rs.getInt("id"));
        order.setUserId(rs.getInt("userId"));
        order.setOrderDate(rs.getDate("orderDate"));
        order.setTotalAmount(rs.getDouble("totalAmount"));
        order.setStatus(rs.getString("status"));
        order.setRecipientName(rs.getString("recipientName"));
        order.setDeliveryAddress(rs.getString("deliveryAddress"));
        order.setRecipientPhone(rs.getString("recipientPhone"));
        order.setDeliveryDate(rs.getDate("deliveryDate") != null ? rs.getDate("deliveryDate") : null);
        return order;
    }
    public List<Order> getListAllOrdersCrurrentAdmin() throws Exception {
        List<Order> orders = new ArrayList<>();
        String query = "SELECT * FROM orders where status IN ('chờ', 'đang giao') ORDER BY orderDate DESC";
        PreparedStatement ps = conn.prepareStatement(query);

        try (ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Order order = extractOrderFromResultSet(rs);
                orders.add(order);
            }
        }
        return orders;
    }

    public List<Order> getListAllOrdersHistoryAdmin() throws SQLException {
        List<Order> orders = new ArrayList<>();
        String query = "SELECT * FROM orders  where status IN ('hoàn thành', 'thất bại','đã hủy') ORDER BY orderDate DESC";
        PreparedStatement ps = conn.prepareStatement(query);

        try (ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Order order = extractOrderFromResultSet(rs);
                orders.add(order);
            }
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
        return orders;
    }
    public boolean updateOrderStatus(int orderId, String status, String recipientName, String recipientPhone, String deliveryAddress) throws SQLException {
        boolean success = false;

        String sql;
        if ("hoàn thành".equalsIgnoreCase(status)) {
            sql = "UPDATE orders SET status = ?, recipientName = ?, recipientPhone = ?, deliveryAddress = ?, deliveryDate = CURRENT_TIMESTAMP WHERE id = ?";
        } else {
            sql = "UPDATE orders SET status = ?, recipientName = ?, recipientPhone = ?, deliveryAddress = ? WHERE id = ?";
        }

        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setString(1, status);
        ps.setString(2, recipientName);
        ps.setString(3, recipientPhone);
        ps.setString(4, deliveryAddress);
        ps.setInt(5, orderId);

        int rowsAffected = ps.executeUpdate();
        if (rowsAffected > 0) {
            success = true;
        }

        return success;
    }

    public boolean updateStatus(int orderId, String newStatus) {
        String sql = "UPDATE orders SET status = ? WHERE id = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, newStatus);
            stmt.setInt(2, orderId);
            int rowsUpdated = stmt.executeUpdate();
            return rowsUpdated > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public static void main(String[] args) throws Exception {
        OrderDao orderDao = new OrderDao();
        //for(Order o : orderDao.getCurrentOrdersForUser(2)){
       //     System.out.println(o);
       // }
        System.out.println(orderDao.getOrder(36));
    }

    public boolean deleteOrder(int i) throws SQLException {
        String query = "DELETE FROM orders WHERE id = ?";
        try (PreparedStatement preparedStatement = conn.prepareStatement(query)) {
            preparedStatement.setInt(1, i);
            int rowsAffected = preparedStatement.executeUpdate();
            return rowsAffected > 0;
        }
    }
}