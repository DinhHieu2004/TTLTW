package com.example.web.dao;

import com.example.web.dao.db.DbConnect;
import com.example.web.dao.model.UserVoucher;
import com.example.web.dao.model.Voucher;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class UserVoucherDao {
    private final Connection conn = DbConnect.getConnection();

    public List<UserVoucher> getUserVoucherById(int userId) throws SQLException {
        List<UserVoucher> list = new ArrayList<>();
        String sql = "SELECT uv.id AS uv_id, uv.user_id, uv.voucher_id, uv.is_used, uv.assigned_at," +
                "       v.id AS v_id, v.name, v.discount, v.startDate, v.endDate" +
                " FROM user_vouchers uv" +
                " JOIN vouchers v ON uv.voucher_id = v.id" +
                " WHERE uv.user_id = ?";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setInt(1, userId);
        ResultSet rs = ps.executeQuery();

        while(rs.next()) {
            UserVoucher uv = new UserVoucher();
            uv.setId(rs.getInt("uv_id"));
            uv.setUserId(rs.getInt("user_id"));
            uv.setVoucherId(rs.getInt("voucher_id"));
            uv.setUsed(rs.getBoolean("is_used"));
            uv.setAssignedAt(rs.getTimestamp("assigned_at"));

            Voucher v = new Voucher();
            v.setId(rs.getInt("v_id"));
            v.setName(rs.getString("name"));
            v.setDiscount(rs.getDouble("discount"));
            v.setStartDate(rs.getTimestamp("startDate"));
            v.setEndDate(rs.getTimestamp("endDate"));

            uv.setVoucher(v);
            list.add(uv);
        }
        return list;
    }

    // thêm voucher cho user
    public boolean assignVoucherToUser(int userId, int voucherId) throws SQLException {
        String sql = "INSERT INTO user_vouchers (user_id, voucher_id, is_used, assigned_at) " +
                "SELECT ?, ?, false, CURRENT_TIMESTAMP " +
                "WHERE EXISTS (SELECT 1 FROM vouchers WHERE id = ?) " +
                "AND EXISTS (SELECT 1 FROM users WHERE id = ?)";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, voucherId);
            ps.setInt(3, voucherId);
            ps.setInt(4, userId);
            return ps.executeUpdate() > 0;
        }
    }

    // set voucher đã dùng
    public boolean markVoucherAsUsed(int userVoucherId) throws SQLException {
        String sql = "UPDATE user_vouchers SET is_used = true " +
                "WHERE id = ? AND is_used = false";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userVoucherId);
            return ps.executeUpdate() > 0;
        }
    }

    // kiểm tra voucher trùng
    public boolean isVoucherAlreadyAssigned(int userId, int voucherId) throws SQLException {
        String sql = "SELECT 1 FROM user_vouchers WHERE user_id = ? AND voucher_id = ? LIMIT 1";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, voucherId);

            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }

    // lấy các voucher chưa dùng
    public List<UserVoucher> getUnusedVouchersByUser(int userId) throws SQLException {
        List<UserVoucher> list = new ArrayList<>();
        String sql = "SELECT uv.*, v.name, v.discount, v.start_date, v.end_date " +
                "FROM user_vouchers uv " +
                "JOIN vouchers v ON uv.voucher_id = v.id " +
                "WHERE uv.user_id = ? AND uv.is_used = false";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    UserVoucher uv = new UserVoucher();
                    uv.setId(rs.getInt("id"));
                    uv.setUserId(rs.getInt("user_id"));
                    uv.setVoucherId(rs.getInt("voucher_id"));
                    uv.setUsed(rs.getBoolean("is_used"));
                    uv.setAssignedAt(rs.getTimestamp("assigned_at"));

                    Voucher voucher = new Voucher();
                    voucher.setId(rs.getInt("voucher_id"));
                    voucher.setName(rs.getString("name"));
                    voucher.setDiscount(rs.getInt("discount"));
                    voucher.setStartDate(rs.getDate("start_date"));
                    voucher.setEndDate(rs.getDate("end_date"));

                    uv.setVoucher(voucher);
                    list.add(uv);
                }
            }
        }
        return list;
    }

}
