package com.example.web.service;

import com.example.web.dao.PaymentMethodDao;
import com.example.web.dao.model.PaymentMethod;

import java.sql.SQLException;
import java.util.List;

public class PaymentMethodService {
    PaymentMethodDao paymentMethodDao = new PaymentMethodDao();
    public PaymentMethodService() {}
    public List<PaymentMethod> getAllPaymentMethods() throws SQLException {
        return paymentMethodDao.getAllPaymentMethod();
    }

    public static void main(String[] args) throws SQLException {
        PaymentMethodDao paymentMethodDao = new PaymentMethodDao();
        for(PaymentMethod p : paymentMethodDao.getAllPaymentMethod()){
            System.out.println(p);
        }
    }
}
