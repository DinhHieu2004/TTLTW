package com.example.web.dao.model;

public class StockInItem {
    private int id;
    private int stockInId;
    private int productId;
    private String productName;
    private int sizeId;
    private String sizeName;
    private double price;
    private int quantity;
    private double totalPrice;
    private String note;
    public StockInItem(int id, int stockInId, int productId, String productName, int sizeId, String sizeName, double price, int quantity, double totalPrice, String note) {
        this.id = id;
        this.stockInId = stockInId;
        this.productId = productId;
        this.productName = productName;
        this.sizeId = sizeId;
        this.sizeName = sizeName;
        this.price = price;
        this.quantity = quantity;
        this.totalPrice = totalPrice;
        this.note = note;
    }

    public StockInItem() {
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getStockInId() {
        return stockInId;
    }

    public void setStockInId(int stockInId) {
        this.stockInId = stockInId;
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

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    public String getSizeName() {
        return sizeName;
    }

    public void setSizeName(String sizeName) {
        this.sizeName = sizeName;
    }
}
