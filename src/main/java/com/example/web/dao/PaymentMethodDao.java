package com.example.web.dao;

import com.example.web.dao.db.DbConnect;
import com.example.web.dao.model.PaymentMethod;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class PaymentMethodDao {
    Connection con = DbConnect.getConnection();
    public List<PaymentMethod> getAllPaymentMethod() throws SQLException {
        List<PaymentMethod> list = new ArrayList<PaymentMethod>();
        String sql = "select * from payment_methods";
        PreparedStatement ps = con.prepareStatement(sql);
        ResultSet rs = ps.executeQuery();
        while (rs.next()){
            PaymentMethod pm = new PaymentMethod();
            pm.setId(rs.getInt("id"));
            pm.setMethodName(rs.getString("methodName"));
            list.add(pm);
        }
        return list;
    }

}
