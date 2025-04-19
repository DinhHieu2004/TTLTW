package com.example.web.service;

import com.example.web.dao.StockIODao;
import com.example.web.dao.model.StockIn;
import com.example.web.dao.model.StockInItem;

import java.sql.SQLException;
import java.util.List;

public class StockIOService {
    private final StockIODao stockIODao = new StockIODao();
    public List<StockIn> getAll() throws SQLException {
        return stockIODao.getAll();
    }
    public int saveStockInWithItems(StockIn stockIn) throws SQLException {
        return stockIODao.saveStockInWithItems(stockIn);
    }

    public StockIn getStockInDetail(String id) throws SQLException {
        return stockIODao.getStockInDetail(Integer.parseInt(id));
    }
}
