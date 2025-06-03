package com.example.web.service;

import com.example.web.dao.ReorderDao;
import com.example.web.dao.model.ReorderAlert;
import com.example.web.dao.model.SlowSellingProduct;

import java.sql.SQLException;
import java.util.List;

public class ReorderAlertService {

    private final ReorderDao reorderDao = new ReorderDao();

    public List<ReorderAlert> getReorderAlerts() throws SQLException {
        return reorderDao.getReorderAlerts();
    }
    public List<SlowSellingProduct> getSlowSellingProducts() throws SQLException {
        return reorderDao.getSlowSellingProducts();
    }
}
