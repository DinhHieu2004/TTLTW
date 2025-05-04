package com.example.web.service;

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

    public List<Order> getCurrentOrdersForUser(int userId) throws Exception {
        return orderDao.getCurrentOrdersForUser(userId);
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
        boolean success = false;
        List<OrderItem> orderItems = new ArrayList<>();

        if ("đã hủy giao hàng".equalsIgnoreCase(status)) {
            orderItems = orderItemDao.getListOrderItem(orderId);
            paintingDao.returnQuantity(orderItems);
        }
        success = orderDao.updateOrderStatus(orderId, status, recipientName, recipientPhone, deliveryAddress);

        return success;
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

    public List<Order> getOrderByDelStatus(String status) throws Exception {
        return orderDao.getOrderByDelStatus(status);
    }

    public boolean isPendingOrder(int id) throws SQLException {
        return orderDao.isPendingOrder(id);
    }
}
