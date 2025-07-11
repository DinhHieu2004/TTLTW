package com.example.web.dao.model;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class StockIn {
    private int id;
    private int createdId;
    private String createdName;
    private int supplierId;
    private String supplier;
    private String note;
    private Date transactionDate;
    private double totalPrice;
    private List<StockInItem> listPro = new ArrayList<>();
    private String status;

    public StockIn(int id, int createdId, int supplierId, String note, double totalPrice, Date transactionDate, String status) {
        this.id = id;
        this.createdId = createdId;
        this.supplierId = supplierId;
        this.note = note;
        this.totalPrice = totalPrice;
        this.transactionDate = transactionDate;
        this.status = status;
    }
    public StockIn(int id, int createdId, String createdName, String supplier, String note, double totalPrice, Date transactionDate, String status) {
        this.id = id;
        this.createdId = createdId;
        this.createdName = createdName;
        this.supplier = supplier;
        this.note = note;
        this.totalPrice = totalPrice;
        this.transactionDate = transactionDate;
        this.status = status;
    }
    public StockIn() {
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

    public String getSupplier() {
        return supplier;
    }

    public void setSupplier(String supplier) {
        this.supplier = supplier;
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

    public List<StockInItem> getListPro() {
        return listPro;
    }

    public void setListPro(List<StockInItem> listPro) {
        this.listPro = listPro;
    }

    public String getCreatedName() {
        return createdName;
    }

    public void setCreatedName(String createdName) {
        this.createdName = createdName;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public int getSupplierId() {
        return supplierId;
    }

    public void setSupplierId(int supplierId) {
        this.supplierId = supplierId;
    }
}
