package com.example.web.dao;

import com.example.web.dao.db.DbConnect;
import com.example.web.dao.model.Artist;
import com.example.web.dao.model.Voucher;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class VoucherDao {
    private Connection conn = DbConnect.getConnection();

    public List<Voucher> getAll() throws SQLException {
        List<Voucher> list = new ArrayList<Voucher>();
        String sql = "select * from vouchers where is_active=1";
        PreparedStatement ps = conn.prepareStatement(sql);
        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
            Voucher voucher = new Voucher();
            voucher.setId(rs.getInt("id"));
            voucher.setName(rs.getString("name"));
            voucher.setDiscount(rs.getDouble("discount"));
            voucher.setActive(rs.getBoolean("is_active"));
            voucher.setCreateAt(rs.getDate("created_at"));
            voucher.setStartDate(rs.getDate("startDate"));
            voucher.setEndDate(rs.getDate("endDate"));
            list.add(voucher);
        }
        return list;

    }
    public List<Voucher> getAllAdmin() throws SQLException {
        List<Voucher> list = new ArrayList<Voucher>();
        String sql = "select * from vouchers";
        PreparedStatement ps = conn.prepareStatement(sql);
        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
            Voucher voucher = new Voucher();
            voucher.setId(rs.getInt("id"));
            voucher.setName(rs.getString("name"));
            voucher.setDiscount(rs.getDouble("discount"));
            voucher.setActive(rs.getBoolean("is_active"));
            voucher.setCreateAt(rs.getDate("created_at"));
            voucher.setStartDate(rs.getDate("startDate"));
            voucher.setEndDate(rs.getDate("endDate"));
            list.add(voucher);
        }
        return list;

    }
    public Voucher getVoucherById(String id) throws SQLException {
        String sql = "select * from vouchers where id = ?";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setString(1, id);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            Voucher voucher = new Voucher();
            voucher.setId(rs.getInt("id"));
            voucher.setName(rs.getString("name"));
            voucher.setDiscount(rs.getDouble("discount"));
            voucher.setActive(rs.getBoolean("is_active"));
            voucher.setCreateAt(rs.getDate("created_at"));
            voucher.setStartDate(rs.getDate("startDate"));
            voucher.setEndDate(rs.getDate("endDate"));
            return voucher;
        }
        return null;
    }




    public boolean deleteVoucher(String i) throws SQLException {
        String query = "delete from vouchers where id = ?";

        try (PreparedStatement preparedStatement = conn.prepareStatement(query)) {
            preparedStatement.setString(1, i);
            int rowsAffected = preparedStatement.executeUpdate();
            return rowsAffected > 0;
        }
    }
    public boolean addVoucher(Voucher voucher) throws SQLException {
        String sql = "INSERT INTO vouchers (name, discount, is_active, startDate, endDate) VALUES (?, ?, ?, ?,?)";
        PreparedStatement statement = conn.prepareStatement(sql);
        statement.setString(1, voucher.getName());
        statement.setDouble(2, voucher.getDiscount());
        statement.setBoolean(3, voucher.isActive());
        statement.setDate(4,new java.sql.Date(voucher.getStartDate().getTime()));
        statement.setDate(5, new java.sql.Date(voucher.getEndDate().getTime()));

        int rowsInserted = statement.executeUpdate();
        return rowsInserted > 0;

    }
    public boolean updateVoucher(Voucher voucher) throws SQLException {
        String updateQuery = "UPDATE vouchers SET name = ?, discount = ?, is_active = ?, startDate = ?, endDate = ? WHERE id = ?";
        PreparedStatement statement = conn.prepareStatement(updateQuery);
        statement.setString(1, voucher.getName());
        statement.setDouble(2, voucher.getDiscount());
        statement.setBoolean(3,voucher.isActive());
        statement.setDate(4, new java.sql.Date(voucher.getStartDate().getTime()));
        statement.setDate(5,new java.sql.Date(voucher.getEndDate().getTime()));
        statement.setInt(6, voucher.getId());

        int rowsAffected = statement.executeUpdate();

        return rowsAffected > 0;


    }

    public static void main(String[] args) throws SQLException {
        VoucherDao dao = new VoucherDao();
        System.out.println(dao.getAllAdmin());
    }
}
