package com.example.web.dao;

import com.example.web.dao.db.DbConnect;
import com.example.web.dao.model.Order;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class OrderDao {
    private Connection conn = DbConnect.getConnection();
    public int createOrder(Order order) throws Exception {
        String sql = "INSERT INTO orders (userId, totalAmount, paymentStatus, deliveryStatus, deliveryDate, recipientName, deliveryAddress, recipientPhone, paymentMethod, shippingFee, appliedVoucherIds, totalPrice) VALUES (?, ?, ?, ?, ?, ?,?,?, ?, ?, ?, ?)";
        PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
        ps.setInt(1, order.getUserId());
        ps.setDouble(2, order.getTotalAmount());
        ps.setString(3, order.getPaymentStatus());
        ps.setString(4, order.getDeliveryStatus());
        ps.setDate(5, order.getDeliveryDate() != null ? (Date) order.getDeliveryDate() : null);
        ps.setString(6, order.getRecipientName());
        ps.setString(7, order.getDeliveryAddress());
        ps.setString(8, order.getRecipientPhone());
        ps.setString(9, order.getPaymentMethod());
        ps.setDouble(10, order.getShippingFee());
        ps.setString(11, order.getAppliedVoucherIds());
        ps.setDouble(12, order.getPriceAfterShipping());

        ps.executeUpdate();
        try (ResultSet rs = ps.getGeneratedKeys()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        throw new Exception("Unable to create order");
    }

    public int createOrder2(Order order) throws Exception {

        String sql = "INSERT INTO orders (userId, totalAmount, paymentStatus, deliveryStatus, deliveryDate, recipientName, deliveryAddress, recipientPhone, paymentMethod, vnpTxnRef, shippingFee, appliedVoucherIds, totalPrice) VALUES (?, ?, ?, ?, ?, ?, ?, ?,?,?, ?, ?, ?)";
        PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
        ps.setInt(1, order.getUserId());
        ps.setDouble(2, order.getTotalAmount());
        ps.setString(3, order.getPaymentStatus());
        ps.setString(4, order.getDeliveryStatus());
        ps.setDate(5, order.getDeliveryDate() != null ? (Date) order.getDeliveryDate() : null);
        ps.setString(6, order.getRecipientName());
        ps.setString(7, order.getDeliveryAddress());
        ps.setString(8, order.getRecipientPhone());
        ps.setString(9, order.getPaymentMethod());
        ps.setString(10, order.getVnpTxnRef());
        ps.setDouble(11, order.getShippingFee());
        ps.setString(12, order.getAppliedVoucherIds());
        ps.setDouble(13, order.getPriceAfterShipping());

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
        String query = "SELECT * FROM orders WHERE userId = ? AND deliveryStatus IN ('chờ', 'đang giao') AND isDelete = 0 ORDER BY orderDate DESC";

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
        String query = "SELECT * FROM orders WHERE userId = ? AND deliveryStatus IN ('hoàn thành', 'giao hàng thất bại','đã hủy giao hàng') AND isDelete = 0 ORDER BY orderDate DESC";


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
        String sql = "SELECT * FROM orders WHERE id = ? AND isDelete = 0 ";
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
        order.setPaymentStatus(rs.getString("paymentStatus"));
        order.setDeliveryStatus(rs.getString("deliveryStatus"));
        order.setRecipientName(rs.getString("recipientName"));
        order.setDeliveryAddress(rs.getString("deliveryAddress"));
        order.setRecipientPhone(rs.getString("recipientPhone"));
        order.setVnpTxnRef(rs.getString("vnpTxnRef"));
        order.setShippingFee(rs.getDouble("shippingFee"));
        order.setPriceAfterShipping(rs.getDouble("totalPrice"));
        order.setDeliveryDate(rs.getDate("deliveryDate") != null ? rs.getDate("deliveryDate") : null);
        order.setShippingFee(rs.getDouble("shippingFee"));
        order.setPriceAfterShipping(rs.getDouble("totalPrice"));
        order.setAppliedVoucherIds(rs.getString("appliedVoucherIds"));
        order.setPaymentMethod(rs.getString("paymentMethod"));
        return order;
    }
    public List<Order> getListAllOrdersCrurrentAdmin() throws Exception {
        List<Order> orders = new ArrayList<>();
        String query = "SELECT * FROM orders where deliveryStatus IN ('chờ', 'đang giao') AND isDelete = 0 ORDER BY orderDate DESC";
        PreparedStatement ps = conn.prepareStatement(query);

        try (ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Order order = extractOrderFromResultSet(rs);
                orders.add(order);
            }
        }
        return orders;
    }

    public List<Order> getListOrderDeleted() throws Exception {
        List<Order> orders = new ArrayList<>();
        String query = "SELECT * FROM orders where isDelete = 1";
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
        String query = "SELECT * FROM orders  where deliveryStatus IN ('hoàn thành', 'giao hàng thất bại','đã hủy giao hàng') AND isDelete = 0 ORDER BY orderDate DESC";
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
            sql = "UPDATE orders SET deliveryStatus = ?, recipientName = ?, recipientPhone = ?, deliveryAddress = ?, deliveryDate = CURRENT_TIMESTAMP WHERE id = ?";
        } else {
            sql = "UPDATE orders SET deliveryStatus = ?, recipientName = ?, recipientPhone = ?, deliveryAddress = ? WHERE id = ?";
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

    public boolean updatePaymentStatus(int orderId, String newPaymentStatus) {
        String sql = "UPDATE orders SET paymentStatus = ? WHERE id = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, newPaymentStatus);
            stmt.setInt(2, orderId);
            int rowsUpdated = stmt.executeUpdate();
            return rowsUpdated > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    public boolean deleteOrder(int i) throws SQLException {
        String query = "UPDATE orders SET isDelete = 1 WHERE id = ?";

        try (PreparedStatement preparedStatement = conn.prepareStatement(query)) {
            preparedStatement.setInt(1, i);
            int rowsAffected = preparedStatement.executeUpdate();
            return rowsAffected > 0;
        }
    }

    public boolean restoreOrder(int i) throws SQLException {
        String query = "UPDATE orders SET isDelete = 0 WHERE id = ?";

        try (PreparedStatement preparedStatement = conn.prepareStatement(query)) {
            preparedStatement.setInt(1, i);
            int rowsAffected = preparedStatement.executeUpdate();
            return rowsAffected > 0;
        }
    }
    public Order getLastOrderOfUser(int userId) throws SQLException {
        String sql = "SELECT * FROM orders WHERE userId = ? ORDER BY id DESC LIMIT 1";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Order order = new Order();
                    order.setId(rs.getInt("id"));
                    order.setUserId(rs.getInt("userId"));
                    order.setPaymentStatus(rs.getString("paymentStatus"));
                    order.setDeliveryStatus(rs.getString("deliveryStatus"));
                    order.setTotalAmount(rs.getDouble("totalAmount"));
                    order.setOrderDate(rs.getTimestamp("orderDate"));
                    order.setDeliveryDate(rs.getTimestamp("deliveryDate"));
                    order.setRecipientName(rs.getString("recipientName"));
                    order.setDeliveryAddress(rs.getString("deliveryAddress"));
                    order.setRecipientPhone(rs.getString("recipientPhone"));
                    order.setShippingFee(rs.getDouble("shippingFee"));
                    order.setPriceAfterShipping(rs.getDouble("totalPrice"));
                    order.setPaymentMethod(rs.getString("paymentMethod"));
                    order.setVnpTxnRef(rs.getString("vnpTxnRef"));
                    order.setAppliedVoucherIds(rs.getString("appliedVoucherIds"));
                    return order;
                }
            }
        }
        return null;
    }
    public List<Order> getOrderByDelStatus(String status) throws Exception {
        List<Order> orders = new ArrayList<>();
        String query = "SELECT * FROM orders where deliveryStatus = ? ORDER BY orderDate ASC";
        PreparedStatement ps = conn.prepareStatement(query);
        ps.setString(1, status);
        try (ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Order order = extractOrderFromResultSet(rs);
                orders.add(order);
            }
        }
        return orders;
    }

    public boolean isPendingOrder(int id) throws SQLException {
        String query = "SELECT COUNT(*) FROM orders WHERE id = ? AND deliveryStatus = 'chờ'";

        try (PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setInt(1, id);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        }
        return false;
    }

    public void updateDeliveryStatus(int id, String status) throws SQLException {
        String sql = "UPDATE orders SET deliveryStatus = ? WHERE id = ?";

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, status);
            stmt.setInt(2, id);

            stmt.executeUpdate();
        }
    }

    public List<String> getVoucherNamesByIds(String[] voucherIdArray) throws SQLException {
        List<String> voucherNames = new ArrayList<>();

        // Tạo chuỗi id
        String idList = String.join(",", voucherIdArray);
        String sql = "SELECT name FROM vouchers WHERE id IN (" + idList + ")";

        try(PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while(rs.next()) {
                voucherNames.add(rs.getString("name"));
            }
        }
        return voucherNames;
    }



}