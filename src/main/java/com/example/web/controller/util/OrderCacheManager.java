package com.example.web.controller.util;

import com.example.web.dao.model.Order;
import com.example.web.dao.model.Painting;
import com.github.benmanes.caffeine.cache.Cache;
import com.github.benmanes.caffeine.cache.Caffeine;

import java.time.Duration;
import java.util.List;


public class OrderCacheManager {
    private final Cache<Integer, List<Order>> currentOrdersCache;
    private final Cache<Integer, List<Order>> historyOrdersCache;

    private final Cache<String, List<Order>> adminCurrentOrdersCache;
    private final Cache<String, List<Order>> adminHistoryOrdersCache;

    public OrderCacheManager() {
        currentOrdersCache = Caffeine.newBuilder()
                .expireAfterWrite(Duration.ofMinutes(10))
                .maximumSize(1000)
                .build();

        historyOrdersCache = Caffeine.newBuilder()
                .expireAfterWrite(Duration.ofMinutes(10))
                .maximumSize(1000)
                .build();

        adminCurrentOrdersCache = Caffeine.newBuilder()
                .expireAfterWrite(Duration.ofMinutes(5))
                .maximumSize(1)
                .build();

        adminHistoryOrdersCache = Caffeine.newBuilder()
                .expireAfterWrite(Duration.ofMinutes(10))
                .maximumSize(1)
                .build();
    }

    public List<Order> getCurrentOrders(int userId) {
        return currentOrdersCache.getIfPresent(userId);
    }

    public void putCurrentOrders(int userId, List<Order> orders) {
        currentOrdersCache.put(userId, orders);
    }

    public void invalidateCurrentOrders(int userId) {
        currentOrdersCache.invalidate(userId);
    }

    public List<Order> getHistoryOrders(int userId) {
        return historyOrdersCache.getIfPresent(userId);
    }

    public void putHistoryOrders(int userId, List<Order> orders) {
        historyOrdersCache.put(userId, orders);
    }

    public void invalidateHistoryOrders(int userId) {
        historyOrdersCache.invalidate(userId);
    }

    public List<Order> getAdminCurrentOrders() {
        return adminCurrentOrdersCache.getIfPresent("admin_current");
    }

    public void putAdminCurrentOrders(List<Order> orders) {
        adminCurrentOrdersCache.put("admin_current", orders);
    }

    public void invalidateAdminCurrentOrders() {
        adminCurrentOrdersCache.invalidate("admin_current");
    }

    public List<Order> getAdminHistoryOrders() {
        return adminHistoryOrdersCache.getIfPresent("admin_history");
    }

    public void putAdminHistoryOrders(List<Order> orders) {
        adminHistoryOrdersCache.put("admin_history", orders);
    }

    public void invalidateAdminHistoryOrders() {
        adminHistoryOrdersCache.invalidate("admin_history");
    }
}
