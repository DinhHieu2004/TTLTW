package com.example.web.service;

import com.example.web.controller.util.OrderCacheManager;
import com.example.web.dao.OrderDao;
import com.example.web.dao.model.Order;

import java.sql.SQLException;
import java.util.List;

public class OrderService {
    private OrderDao orderDao = new OrderDao();
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

    public List<Order> getHistoryOrder(int userId) throws Exception {
        List<Order> cached = cacheManager.getHistoryOrders(userId);
        if (cached != null) {
            return cached;
        }

        List<Order> orders = orderDao.getHistoryOrder(userId);
        cacheManager.putHistoryOrders(userId, orders);
        return orders;
    }
    public Order getOrder(int orderId) throws Exception {
        return orderDao.getOrder(orderId);
    }

    public boolean updateOrderStatus(int orderId, String status, String recipientName, String recipientPhone, String deliveryAddress) throws Exception {
        return orderDao.updateOrderStatus(orderId, status,recipientName,recipientPhone, deliveryAddress);
    }

    public boolean updatePaymentStatus(int orderId, String paymentStatus) {
        return orderDao.updatePaymentStatus(orderId, paymentStatus);
    }

    public boolean deleteOrder(int i) throws SQLException {
        return orderDao.deleteOrder(i);
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

}
