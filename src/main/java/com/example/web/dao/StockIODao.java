package com.example.web.dao;

import com.example.web.dao.db.DbConnect;
import com.example.web.dao.model.StockIn;
import com.example.web.dao.model.StockInItem;

import java.sql.*;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class StockIODao {
    static Connection conn = DbConnect.getConnection();

    public int saveStockInWithItems(StockIn stockIn) {
        try {
            conn.setAutoCommit(false);

            int stockInId = addStockInTrans(stockIn);
            if (stockInId == -1) {
                conn.rollback();
                return -1;
            }

            boolean success = addStockInItems(stockInId, stockIn.getListPro());
            if (!success) {
                conn.rollback();
                return -1;
            }

            conn.commit();
            return stockInId;
        } catch (SQLException e) {
            try {
                conn.rollback();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            e.printStackTrace();
            return -1;
        } finally {
            try {
                conn.setAutoCommit(true);
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
    public int addStockInTrans(StockIn stockIn) throws SQLException{
        String stockInSql = "INSERT INTO stock_in (createdId, supplier, note, totalPrice, importDate) VALUES (?, ?, ?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(stockInSql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, stockIn.getCreatedId());
            ps.setString(2, stockIn.getSupplier());
            ps.setString(3, stockIn.getNote());
            ps.setDouble(4, stockIn.getTotalPrice());
            ps.setDate(5, new java.sql.Date(stockIn.getTransactionDate().getTime()));

            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
        e.printStackTrace();
        throw new SQLException("Lỗi khi thêm nhập kho");
        }
        return -1;
    }

    public List<StockIn> getAll() throws SQLException{
        List<StockIn> stockInList = new ArrayList<>();
        String sql = "SELECT * FROM stock_in";

        PreparedStatement ps = conn.prepareStatement(sql);
        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
            int id = rs.getInt("id");
            int createdId = rs.getInt("createdId");
            String supplier = rs.getString("supplier");
            String note = rs.getString("note");
            double totalPrice = rs.getDouble("totalPrice");
            Date transactionDate = rs.getDate("importDate");

            StockIn stockIn = new StockIn(id, createdId, supplier, note, totalPrice, transactionDate);
            stockInList.add(stockIn);
        }
        return stockInList;
    }

    public boolean addStockInItems(int stockInId, List<StockInItem> listItem) throws SQLException {
        String insertSql = "INSERT INTO stock_in_items (stockInId, paintingId, sizeId, price, quantity, totalPrice, note) VALUES (?, ?, ?, ?, ?, ?, ?)";

        try (PreparedStatement ps = conn.prepareStatement(insertSql)) {
            for (StockInItem item : listItem) {
                ps.setInt(1, stockInId);
                ps.setInt(2, item.getProductId());
                ps.setInt(3, item.getSizeId());
                ps.setDouble(4, item.getPrice());
                ps.setInt(5, item.getQuantity());
                ps.setDouble(6, item.getTotalPrice());
                ps.setString(7, item.getNote());

                ps.addBatch();
            }

            int[] result = ps.executeBatch();
            for (int res : result) {
                if (res == Statement.EXECUTE_FAILED) {
                    return false;
                }
            }
            return true;
        }
    }
}
