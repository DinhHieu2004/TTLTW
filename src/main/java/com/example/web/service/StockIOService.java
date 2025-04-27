package com.example.web.service;

import com.example.web.dao.StockIODao;
import com.example.web.dao.model.StockIn;
import com.example.web.dao.model.StockInItem;
import com.example.web.dao.model.StockOut;

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

    public boolean deleteStockInById(String id) {
        return stockIODao.deleteStockInById(Integer.parseInt(id));
    }

    public StockIn getSIById(int stockInId) throws SQLException {
        return stockIODao.getSIById(stockInId);
    }

    public List<StockOut> getAllOut() throws SQLException {
        return stockIODao.getAllOut();
    }

    public StockOut getStockOutDetail(String id) throws SQLException{
        return stockIODao.getStockOutDetail(Integer.parseInt(id));
    }

    public int saveStockOutWithItems(StockOut stockOut) {
        return stockIODao.saveStockOutWithItems(stockOut);
    }

    public StockOut getSOById(int stockOutId) throws SQLException {
        return stockIODao.getSOById(stockOutId);
    }

    public boolean deleteStockOutById(String id) {
        return stockIODao.deleteStockOutById(Integer.parseInt(id));
    }
}
