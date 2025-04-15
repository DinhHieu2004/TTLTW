package com.example.web.dao.model;

import org.w3c.dom.stylesheets.LinkStyle;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class InventoryTransactions {
    private int id;
    private String type;
    private int employeeId;
    private int partnerId;
    private String note;
    private Date transactionDate;
    private double totalPrice;
    private List<InventoryTransDetail> listPro = new ArrayList<>();


    public InventoryTransactions(int id, String type, int employeeId, String note, double totalPrice,  Date transactionDate) {
        this.id = id;
        this.type = type;
        this.employeeId = employeeId;
        this.note = note;
        this.transactionDate = transactionDate;
    }
    public InventoryTransactions(int id, String type, int employeeId, int partnerId, String note, double totalPrice,  Date transactionDate) {
        this.id = id;
        this.type = type;
        this.employeeId = employeeId;
        this.partnerId = partnerId;
        this.note = note;
        this.transactionDate = transactionDate;
    }

    public InventoryTransactions() {
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public int getEmployeeId() {
        return employeeId;
    }

    public void setEmployeeId(int employeeId) {
        this.employeeId = employeeId;
    }

    public int getPartnerId() {
        return partnerId;
    }

    public void setPartnerId(int partnerId) {
        this.partnerId = partnerId;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    public Date getTransactionDate() {
        return transactionDate;
    }

    public void setTransactionDate(Date transactionDate) {
        this.transactionDate = transactionDate;
    }

    public double getTotalPrice() {
        double re = 0;
        for (InventoryTransDetail detail: listPro){
            re += detail.getTotalPrice();
        }
        return re;
    }

    public void setTotalPrice(double totalPrice) {
        this.totalPrice = totalPrice;
    }
}
