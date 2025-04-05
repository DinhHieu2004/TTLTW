package com.example.web.dao;

import com.example.web.dao.db.DbConnect;
import com.example.web.dao.model.Payment;

import java.sql.Connection;
import java.sql.PreparedStatement;

public class PaymentDao {
    Connection conn = DbConnect.getConnection();

    public void createPayment(Payment payment) throws Exception {
        String sql = "INSERT INTO payments (orderId, userId, methodId, paymentStatus, paymentDate, transactionId) VALUES (?, ?, ?, ?, ?, ?)";
        PreparedStatement ps = conn.prepareStatement(sql);

        ps.setInt(1, payment.getOrderId());
        ps.setInt(2, payment.getUserId());
        ps.setInt(3, payment.getMethodId());
        ps.setString(4, payment.getPaymentStatus());
        ps.setTimestamp(5, java.sql.Timestamp.valueOf(payment.getPaymentDate()));
        ps.setString(6, payment.getTransactionId());


        ps.executeUpdate();
    }

}