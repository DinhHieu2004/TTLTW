package com.example.web.dao.model;

public class InventoryTransDetail {
    private int id;
    private int inTransId;
    private int productId;
    private int sizeId;
    private double price;
    private int quantity;
    private double totalPrice;
    private String note;

    public InventoryTransDetail(int id, int inTransId, int productId, int sizeId, double price, int quantity, double totalPrice, String note) {
        this.id = id;
        this.inTransId = inTransId;
        this.productId = productId;
        this.sizeId = sizeId;
        this.price = price;
        this.quantity = quantity;
        this.totalPrice = totalPrice;
        this.note = note;
    }

    public InventoryTransDetail() {
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getInTransId() {
        return inTransId;
    }

    public void setInTransId(int inTransId) {
        this.inTransId = inTransId;
    }

    public int getProductId() {
        return productId;
    }

    public void setProductId(int productId) {
        this.productId = productId;
    }

    public int getSizeId() {
        return sizeId;
    }

    public void setSizeId(int sizeId) {
        this.sizeId = sizeId;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public double getTotalPrice() {
        return this.price * this.quantity;
    }

    public void setTotalPrice(double totalPrice) {
        this.totalPrice = totalPrice;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }
}
