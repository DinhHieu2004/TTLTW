package com.example.web.dao.model;

import java.math.BigDecimal;

public class OrderItem  implements java.io.Serializable {
    private int id;
    private int orderId;
    private int paintingId;
    private String img;
    private int sizeId;
    private double price;
    private int quantity;
    private String name;
    private String sizeDescription;

    // Getters and Setters
    public int getId() {
        return id;
    }

    public String getImg() {
        return img;
    }

    public void setImg(String img) {
        this.img = img;
    }

    public String getSizeDescription() {
        return sizeDescription;
    }

    public void setSizeDescription(String sizeDescription) {
        this.sizeDescription = sizeDescription;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public void setId(int id) {
        this.id = id;
    }
    public int getSizeId() {
        return sizeId;
    }
    public void setSizeId(int sizeId) {
        this.sizeId = sizeId;
    }
    public int getOrderId() {
        return orderId;
    }
    public void setOrderId(int orderId) {
        this.orderId = orderId;
    }
    public int getPaintingId() {
        return paintingId;
    }
    public void setPaintingId(int paintingId) {
        this.paintingId = paintingId;
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

    @Override
    public String toString() {
        return "OrderItem{" +
                "id=" + id +
                ", orderId=" + orderId +
                ", paintingId=" + paintingId +
                ", img='" + img + '\'' +
                ", sizeId=" + sizeId +
                ", price=" + price +
                ", quantity=" + quantity +
                ", name='" + name + '\'' +
                ", sizeDescription='" + sizeDescription + '\'' +
                '}';
    }
}
