package com.example.web.dao.model;

import java.io.Serializable;

public class PaymentMethod implements Serializable {
    private int id;
    private String methodName;

    public PaymentMethod(int id, String methodName) {
        this.id = id;
        this.methodName = methodName;
    }
    public PaymentMethod() {}

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getMethodName() {
        return methodName;
    }

    public void setMethodName(String methodName) {
        this.methodName = methodName;
    }

    @Override
    public String toString() {
        return "PaymentMethod{" +
                "id=" + id +
                ", methodName='" + methodName + '\'' +
                '}';
    }
}
