package com.example.web.dao.model;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class StockOut {
    private int id;
    private int createdId;
    private String createdName;
    private String reason;
    private Integer orderId;
    private String note;
    private Date transactionDate;
    private double totalPrice;
    private List<StockOutItem> listPro = new ArrayList<>();

    public StockOut(int id, int createdId, String reason, Integer orderId, String note, Date transactionDate, double totalPrice) {
        this.id = id;
        this.createdId = createdId;
        this.reason = reason;
        this.orderId = orderId;
        this.note = note;
        this.transactionDate = transactionDate;
        this.totalPrice = totalPrice;
    }

    public StockOut() {
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getCreatedId() {
        return createdId;
    }

    public void setCreatedId(int createdId) {
        this.createdId = createdId;
    }

    public String getCreatedName() {
        return createdName;
    }

    public void setCreatedName(String createdName) {
        this.createdName = createdName;
    }

    public String getReason() {
        return reason;
    }

    public void setReason(String reason) {
        this.reason = reason;
    }

    public Integer getOrderId() {
        return orderId;
    }

    public void setOrderId(Integer orderId) {
        this.orderId = orderId;
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
        return totalPrice;
    }

    public void setTotalPrice(double totalPrice) {
        this.totalPrice = totalPrice;
    }

    public List<StockOutItem> getListPro() {
        return listPro;
    }

    public void setListPro(List<StockOutItem> listPro) {
        this.listPro = listPro;
    }
}
