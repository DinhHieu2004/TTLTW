package com.example.web.dao;

import com.example.web.dao.db.DbConnect;
import com.example.web.dao.model.DiscountCode;

import java.sql.*;
import java.util.*;

public class DiscountCodeDao {
    private Connection conn = DbConnect.getConnection();;


    public List<DiscountCode> getActiveTimeBasedCodes() throws SQLException {
        String sql = "SELECT * FROM discount_code WHERE trigger_event = 'TIME_BASED' AND is_active = 1 AND NOW() BETWEEN start_time AND end_time";
        List<DiscountCode> list = new ArrayList<>();
        PreparedStatement ps = conn.prepareStatement(sql);
        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
            list.add(new DiscountCode(rs));
        }
        return list;
    }

    public void insertDiscountCode(DiscountCode code) throws SQLException {
        String sql = "INSERT INTO discount_code (code, description, discount_percent, trigger_event, is_active) VALUES (?, ?, ?, ?, ?)";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setString(1, code.getCode());
        ps.setString(2, code.getDescription());
        ps.setInt(3, code.getDiscountPercent());
        ps.setString(4, code.getTriggerEvent());
        ps.setBoolean(5, code.isActive());
        ps.executeUpdate();
    }

}
