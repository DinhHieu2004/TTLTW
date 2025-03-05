package com.example.web.service;

import com.example.web.dao.OrderItemDao;
import com.example.web.dao.model.OrderItem;

import java.sql.SQLException;
import java.util.List;

public class OrderItemService {
    private OrderItemDao orderItemDao;
    public List<OrderItem> getOrderItems(int orderId) throws SQLException {
        orderItemDao = new OrderItemDao();
        return orderItemDao.getListOrderItem(orderId);
    }


}
