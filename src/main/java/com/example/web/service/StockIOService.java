package com.example.web.service;

import com.example.web.dao.StockIODao;
import com.example.web.dao.model.StockIn;
import com.example.web.dao.model.StockInItem;
import com.example.web.dao.model.StockOut;
import com.example.web.dao.model.StockOutItem;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class StockIOService {
    private final StockIODao stockIODao = new StockIODao();
    private final PaintingService paintingService = new PaintingService();
    private final OrderService orderService = new OrderService();
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

    public boolean applyStockOutById(String id) throws SQLException {
        List<StockOutItem> items = stockIODao.findItemsByStockOutId(Integer.parseInt(id));
        boolean isDelivery = stockIODao.getSOById(Integer.parseInt(id)).getReason().equals("Giao hàng");
        if(paintingService.applySO(items, isDelivery)){
            stockIODao.updateStatus("stock_out", Integer.parseInt(id));
            if(isDelivery){
                int orderId = stockIODao.getSOById(Integer.parseInt(id)).getOrderId();
                orderService.updateDeliveryStatus(orderId,"đang giao");
            }
            return true;
        }
        return false;
    }
    public boolean applyStockInById(String id) throws SQLException {
        List<StockInItem> items = stockIODao.findItemsByStockInId(Integer.parseInt(id));
        if(paintingService.applySI(items)){
            stockIODao.updateStatus("stock_in", Integer.parseInt(id));
            return true;
        }
        return false;
    }

    public List<String> getInsufficientStockItems(String id) throws SQLException {
        List<StockOutItem> items = stockIODao.findItemsByStockOutId(Integer.parseInt(id));
        List<String> insufficientItems = new ArrayList<>();

        for (StockOutItem item : items) {
            int currentStock = paintingService.getQuantity(item.getProductId(), item.getSizeId());
            if (currentStock < item.getQuantity()) {
                String productName = paintingService.getPainting(item.getProductId()).getTitle();
                insufficientItems.add(String.format("%s (Size: %s, Tồn: %d, Cần: %d)",
                        productName, item.getSizeId(), currentStock, item.getQuantity()));
            }
        }

        return insufficientItems;
    }
}
