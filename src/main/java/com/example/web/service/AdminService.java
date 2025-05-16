package com.example.web.service;

import com.example.web.dao.AdminDao;
import com.example.web.dao.model.BestSalePaiting;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

public class AdminService {
    private AdminDao adminDao = new AdminDao();

    public double getTotalRevenue(String startDate, String endDate) throws SQLException {
        return adminDao.getTotalRevenue(startDate, endDate);
    }

    public int getTotalOrders(String startDate, String endDate) throws SQLException {
        return adminDao.getTotalOrders(startDate, endDate);
    }

    public int getTotalUsers() throws SQLException {
        return adminDao.getTotalUsers();
    }

    public int getTotalProducts() throws SQLException {
        return adminDao.getTotalProducts();
    }

    public Map<String, Integer> getOrderStatusCount(String startDate, String endDate) throws SQLException {
        return adminDao.getOrderStatusCount(startDate, endDate);
    }

    public Map<String, Double> getRevenueByArtist(String startDate, String endDate) throws SQLException {
        return adminDao.getArtistRevenueMap(startDate, endDate);
    }

    public List<Map<String, Object>> getAverageRatings(String startDate, String endDate) throws SQLException {
        return adminDao.getAverageRatings(startDate, endDate);
    }

    public List<BestSalePaiting> getBestSalePaiting(String startDate, String endDate) throws SQLException {
        return adminDao.getBestSellingPaintings(startDate, endDate);
    }
}