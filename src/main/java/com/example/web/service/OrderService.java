package com.example.web.service;

import com.example.web.dao.OrderDao;
import com.example.web.dao.model.Order;

import java.sql.SQLException;
import java.util.List;

public class OrderService {
    private OrderDao orderDao = new OrderDao();

    public List<Order> getCurrentOrdersForUser(int userId) throws Exception {
        return orderDao.getCurrentOrdersForUser(userId);
    }
    public Order getLastOrderOfUser(int userId) throws SQLException {
        return orderDao.getLastOrderOfUser(userId);
    }
    public List<Order> getHistoryOrder(int userId) throws Exception {
        return orderDao.getHistoryOrder(userId);
    }
    public Order getOrder(int orderId) throws Exception {
        return orderDao.getOrder(orderId);
    }
    public List<Order> getOrderCurrentAdmin() throws Exception {
        return orderDao.getListAllOrdersCrurrentAdmin();
    }
    public List<Order> getOrderHistoryAdmin() throws Exception {
        return orderDao.getListAllOrdersHistoryAdmin();
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

    public static void main(String[] args) throws Exception {
        OrderService orderService = new OrderService();
        System.out.println(orderService.getCurrentOrdersForUser(4));
    }
}
