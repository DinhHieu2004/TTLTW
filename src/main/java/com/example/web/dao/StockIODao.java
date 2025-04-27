package com.example.web.dao;

import com.example.web.dao.db.DbConnect;
import com.example.web.dao.model.StockIn;
import com.example.web.dao.model.StockInItem;
import com.example.web.dao.model.StockOut;
import com.example.web.dao.model.StockOutItem;

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
        String sql = "SELECT si.*, u.fullName as createdName FROM stock_in si JOIN users u ON si.createdId = u.id";

        PreparedStatement ps = conn.prepareStatement(sql);
        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
            int id = rs.getInt("id");
            int createdId = rs.getInt("createdId");
            String createdName = rs.getString("createdName");
            String supplier = rs.getString("supplier");
            String note = rs.getString("note");
            double totalPrice = rs.getDouble("totalPrice");
            Date transactionDate = rs.getDate("importDate");

            StockIn stockIn = new StockIn(id, createdId, createdName,  supplier, note, totalPrice, transactionDate);
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

    public StockIn getStockInDetail(int id) throws SQLException {
        StockIn stockIn = null;

        String sql = "SELECT si.*, u.fullName FROM stock_in si JOIN users u ON si.createdId = u.id WHERE si.id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                stockIn = new StockIn();
                stockIn.setId(rs.getInt("id"));
                stockIn.setCreatedId(rs.getInt("createdId"));
                stockIn.setCreatedName(rs.getString("fullName"));
                stockIn.setSupplier(rs.getString("supplier"));
                stockIn.setNote(rs.getString("note"));
                stockIn.setTransactionDate(rs.getDate("importDate"));
                stockIn.setTotalPrice(rs.getDouble("totalPrice"));
                stockIn.setListPro(findItemsByStockInId(id));
            }
        }

        return stockIn;
    }

    private List<StockInItem> findItemsByStockInId(int stockInId) throws SQLException {
        List<StockInItem> items = new ArrayList<>();

        String sql = "SELECT sii.*, p.title AS productName, s.sizeDescription " +
                "FROM stock_in_items sii " +
                "JOIN paintings p ON sii.paintingId = p.id " +
                "JOIN sizes s ON sii.sizeId = s.id " +
                "WHERE sii.stockInId = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, stockInId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                StockInItem item = new StockInItem();
                item.setId(rs.getInt("id"));
                item.setStockInId(rs.getInt("stockInId"));
                item.setProductId(rs.getInt("paintingId"));
                item.setProductName(rs.getString("productName"));
                item.setSizeId(rs.getInt("sizeId"));
                item.setSizeName(rs.getString("sizeDescription"));
                item.setPrice(rs.getDouble("price"));
                item.setQuantity(rs.getInt("quantity"));
                item.setTotalPrice(rs.getDouble("totalPrice"));
                item.setNote(rs.getString("note"));
                items.add(item);
            }
        }

        return items;
    }

    public boolean deleteStockInById(int id) {
        String deleteStockInSQL = "DELETE FROM stock_in WHERE id = ?";
        String deleteStockInItemsSQL = "DELETE FROM stock_in_items WHERE stockInId = ?";

        try {
            conn.setAutoCommit(false);

            try (PreparedStatement ps = conn.prepareStatement(deleteStockInItemsSQL)) {
                ps.setInt(1, id);
                int rowsDeletedItems = ps.executeUpdate();
                if (rowsDeletedItems == 0) {
                    conn.rollback();
                    return false;
                }
            }

            try (PreparedStatement ps = conn.prepareStatement(deleteStockInSQL)) {
                ps.setInt(1, id);
                int rowsDeletedStockIn = ps.executeUpdate();
                if (rowsDeletedStockIn == 0) {
                    conn.rollback();
                    return false;
                }
            }
            conn.commit();
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            try {
                conn.rollback();
            } catch (SQLException rollbackEx) {
                rollbackEx.printStackTrace();
            }
            return false;
        } finally {
            try {
                conn.setAutoCommit(true);
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
    public StockIn getSIById(int stockInId) throws SQLException {
        StockIn stockIn = null;
        String sql = "SELECT si.*, u.fullName as createdName FROM stock_in si JOIN users u ON si.createdId = u.id" +
                " WHERE si.id = ?";

        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setInt(1, stockInId);
        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
            int id = rs.getInt("id");
            int createdId = rs.getInt("createdId");
            String createdName = rs.getString("createdName");
            String supplier = rs.getString("supplier");
            String note = rs.getString("note");
            double totalPrice = rs.getDouble("totalPrice");
            Date transactionDate = rs.getDate("importDate");

            stockIn = new StockIn(id, createdId, createdName,  supplier, note, totalPrice, transactionDate);
        }
        return stockIn;
    }

    public List<StockOut> getAllOut() throws SQLException {
        List<StockOut> stockOutList = new ArrayList<>();
        String sql = "SELECT so.*, u.fullName as createdName FROM stock_out so JOIN users u ON so.createdId = u.id";

        PreparedStatement ps = conn.prepareStatement(sql);
        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
            int id = rs.getInt("id");
            int createdId = rs.getInt("createdId");
            String createdName = rs.getString("createdName");
            String reason = rs.getString("reason");
            String note = rs.getString("note");
            int orderId = rs.getInt("orderId");
            double totalPrice = rs.getDouble("totalPrice");
            Date transactionDate = rs.getDate("exportDate");

            StockOut stockOut = new StockOut(id, createdId, createdName, reason, orderId, note, transactionDate, totalPrice);
            stockOutList.add(stockOut);
        }
        return stockOutList;
    }

    public StockOut getStockOutDetail(int id) throws SQLException {
        StockOut stockOut = null;

        String sql = "SELECT so.*, u.fullName FROM stock_out so JOIN users u ON si.createdId = u.id WHERE so.id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                stockOut = new StockOut();
                stockOut.setId(rs.getInt("id"));
                stockOut.setCreatedId(rs.getInt("createdId"));
                stockOut.setCreatedName(rs.getString("fullName"));
                stockOut.setReason(rs.getString("reason"));
                stockOut.setNote(rs.getString("note"));
                stockOut.setTransactionDate(rs.getDate("exportDate"));
                stockOut.setTotalPrice(rs.getDouble("totalPrice"));
                stockOut.setListPro(findItemsByStockOutId(id));
            }
        }

        return stockOut;
    }

    private List<StockOutItem> findItemsByStockOutId(int id) throws SQLException {
        List<StockOutItem> items = new ArrayList<>();

        String sql = "SELECT soi.*, p.title AS productName, s.sizeDescription " +
                "FROM stock_out_items soi " +
                "JOIN paintings p ON sii.paintingId = p.id " +
                "JOIN sizes s ON soi.sizeId = s.id " +
                "WHERE soi.stockOutId = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                StockOutItem item = new StockOutItem();
                item.setId(rs.getInt("id"));
                item.setStockOutId(rs.getInt("stockOutId"));
                item.setProductId(rs.getInt("paintingId"));
                item.setProductName(rs.getString("productName"));
                item.setSizeId(rs.getInt("sizeId"));
                item.setSizeName(rs.getString("sizeDescription"));
                item.setPrice(rs.getDouble("price"));
                item.setQuantity(rs.getInt("quantity"));
                item.setTotalPrice(rs.getDouble("totalPrice"));
                item.setNote(rs.getString("note"));
                items.add(item);
            }
        }

        return items;
    }

    public int saveStockOutWithItems(StockOut stockOut) {
        try {
            conn.setAutoCommit(false);

            int stockOutId = addStockOutTrans(stockOut);
            if (stockOutId == -1) {
                conn.rollback();
                return -1;
            }

            boolean success = addStockOutItems(stockOutId, stockOut.getListPro());
            if (!success) {
                conn.rollback();
                return -1;
            }

            conn.commit();
            return stockOutId;
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

    private boolean addStockOutItems(int stockOutId, List<StockOutItem> listItem) throws SQLException {
        String insertSql = "INSERT INTO stock_out_items (stockOutId, paintingId, sizeId, price, quantity, totalPrice, note) VALUES (?, ?, ?, ?, ?, ?, ?)";

        try (PreparedStatement ps = conn.prepareStatement(insertSql)) {
            for (StockOutItem item : listItem) {
                ps.setInt(1, stockOutId);
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

    private int addStockOutTrans(StockOut stockOut) throws SQLException{
        String stockOutSql = "INSERT INTO stock_out (createdId, reason, orderId, note, totalPrice, exportDate) VALUES (?, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(stockOutSql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, stockOut.getCreatedId());
            ps.setString(2, stockOut.getReason());
            if (stockOut.getOrderId() <= 0) {
                ps.setNull(3, java.sql.Types.INTEGER);
            } else {
                ps.setInt(3, stockOut.getOrderId());
            }
            ps.setString(4, stockOut.getNote());
            ps.setDouble(5, stockOut.getTotalPrice());
            ps.setDate(6, new java.sql.Date(stockOut.getTransactionDate().getTime()));

            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw new SQLException("Lỗi khi thêm xuất kho");
        }
        return -1;
    }

    public StockOut getSOById(int stockOutId) throws SQLException {
        StockOut stockOut = null;
        String sql = "SELECT so.*, u.fullName as createdName FROM stock_out so JOIN users u ON so.createdId = u.id" +
                " WHERE so.id = ?";

        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setInt(1, stockOutId);
        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
            int id = rs.getInt("id");
            int createdId = rs.getInt("createdId");
            String createdName = rs.getString("createdName");
            String reason = rs.getString("reason");
            String note = rs.getString("note");
            double totalPrice = rs.getDouble("totalPrice");
            Date transactionDate = rs.getDate("exportDate");

            stockOut = new StockOut(id, createdId, createdName,  reason, note, transactionDate, totalPrice);
        }
        return stockOut;
    }
}
