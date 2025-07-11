package com.example.web.service;

import com.example.web.controller.util.OrderCacheManager;
import com.example.web.dao.OrderDao;
import com.example.web.dao.OrderItemDao;
import com.example.web.dao.PaintingDao;
import com.example.web.dao.model.Order;
import com.example.web.dao.model.OrderItem;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class OrderService {
    private OrderDao orderDao = new OrderDao();
    private PaintingDao paintingDao = new PaintingDao();
    private OrderItemDao orderItemDao = new OrderItemDao();

    private OrderCacheManager cacheManager = new OrderCacheManager();


    public List<Order> getCurrentOrdersForUser(int userId) throws Exception {
        List<Order> cached = cacheManager.getCurrentOrders(userId);
        if (cached != null) {
            return cached;
        }

        List<Order> orders = orderDao.getCurrentOrdersForUser(userId);
        cacheManager.putCurrentOrders(userId, orders);
        return orders;
    }
    public Order getLastOrderOfUser(int userId) throws SQLException {
        return orderDao.getLastOrderOfUser(userId);
    }
    public List<Order> getHistoryOrder(int userId) throws Exception {
        List<Order> cached = cacheManager.getHistoryOrders(userId);
        if (cached != null) {
            return cached;
        }

        List<Order> orders = orderDao.getHistoryOrder(userId);
        cacheManager.putHistoryOrders(userId, orders);
        return orders;
    }
    public List<Order> getOrdersForUser(int userId) throws Exception {
        return orderDao.getOrdersForUser(userId);
    }

    public Order getOrder(int orderId) throws Exception {
        return orderDao.getOrder(orderId);
    }

    public boolean updateOrderStatus(int orderId, String status, String recipientName, String recipientPhone, String deliveryAddress) throws Exception {
        boolean success = false;
        List<OrderItem> orderItems = new ArrayList<>();

        if ("đã hủy giao hàng".equalsIgnoreCase(status)) {
            orderItems = orderItemDao.getListOrderItem(orderId);
            paintingDao.returnQuantity(orderItems);
        }
        success = orderDao.updateOrderStatus(orderId, status, recipientName, recipientPhone, deliveryAddress);

        if (success) {
            Order order = orderDao.getOrder(orderId);
            if (order != null) {
                int userId = order.getUserId();

                cacheManager.invalidateCurrentOrders(userId);
                cacheManager.invalidateHistoryOrders(userId);
            }

            cacheManager.invalidateAdminCurrentOrders();
            cacheManager.invalidateAdminHistoryOrders();
        }

        return success;
    }

    public boolean updatePaymentStatus(int orderId, String paymentStatus) {
        boolean success = orderDao.updatePaymentStatus(orderId, paymentStatus);

        if (success) {
            try {
                Order order = orderDao.getOrder(orderId);
                if (order != null) {
                    int userId = order.getUserId();
                    cacheManager.invalidateCurrentOrders(userId);
                    cacheManager.invalidateHistoryOrders(userId);
                }
                cacheManager.invalidateAdminCurrentOrders();
                cacheManager.invalidateAdminHistoryOrders();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        return success;
    }

    public boolean deleteOrder(int orderId) throws SQLException {
        boolean success = orderDao.deleteOrder(orderId);

        if (success) {
            try {
                Order order = orderDao.getOrder(orderId);
                if (order != null) {
                    int userId = order.getUserId();
                    cacheManager.invalidateCurrentOrders(userId);
                    cacheManager.invalidateHistoryOrders(userId);
                }
                cacheManager.invalidateAdminCurrentOrders();
                cacheManager.invalidateAdminHistoryOrders();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        return success;
    }

    public List<Order> getOrderCurrentAdmin() throws Exception {
        List<Order> cached = cacheManager.getAdminCurrentOrders();
        if (cached != null) {
            return cached;
        }

        List<Order> orders = orderDao.getListAllOrdersCrurrentAdmin();
        cacheManager.putAdminCurrentOrders(orders);
        return orders;
    }

    public List<Order> getOrderHistoryAdmin() throws Exception {
        List<Order> cached = cacheManager.getAdminHistoryOrders();
        if (cached != null) {
            return cached;
        }

        List<Order> orders = orderDao.getListAllOrdersHistoryAdmin();
        cacheManager.putAdminHistoryOrders(orders);
        return orders;
    }
    public List<Order> getOrderByDelStatus(String status) throws Exception {
        return orderDao.getOrderByDelStatus(status);
    }

    public boolean isPendingOrder(int id) throws SQLException {
        return orderDao.isPendingOrder(id);
    }
    public void updateDeliveryStatus(int id, String status) throws SQLException {
        orderDao.updateDeliveryStatus(id, status);
    }

    public List<String> getVoucherNamesByIds(String[] voucherIdArray) throws SQLException {
        return orderDao.getVoucherNamesByIds(voucherIdArray);
    }

    public List<Order> getOrdersDeleted() throws Exception {
        return orderDao.getListOrderDeleted();
    }
    public boolean restoreOrder(int id) throws Exception {
        return orderDao.restoreOrder(id);
    }

}
