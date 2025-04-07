package com.example.web.dao.cart;

import java.io.Serializable;
import java.math.BigDecimal;

public class CartPainting implements Serializable {
    private int productId;
    private String productName;
    private String sizeDescriptions;
    private String sizeId;
    private String imageUrl;
    private int quantity;
    private double price;
    private double totalPrice;
    private int quanlytiOfSize;
    private double discountPrice;
    private double discountPercent;
    private double weight;


    public CartPainting(int productId, String productName, String sizeId,String sizeDescriptions,double weight, int quantity, double price, String imageUrl, int quanlytiOfSize , double discountPercent) {
        this.productId = productId;
        this.productName = productName;
        this.sizeDescriptions = sizeDescriptions;
        this.sizeId = sizeId;
        this.quantity = quantity;
        this.price = price;
        this.totalPrice = price * quantity;
        this.imageUrl = imageUrl;
        this.discountPrice = totalPrice * (1-discountPercent/ 100);
        this.quanlytiOfSize = quanlytiOfSize;
        this.discountPercent = discountPercent;
        this.weight = weight;
    }
    public CartPainting() {

    }

    public int getQuanlytiOfSize() {
        return quanlytiOfSize;
    }

    public double getWeight() {
        return weight;
    }

    public void setWeight(double weight) {
        this.weight = weight;
    }

    public double getDiscountPrice() {
        return  this.discountPrice ;
    }

    public void setDiscountPrice(double discountPrice) {
        this.discountPrice = discountPrice;
    }

    public double getDiscountPercent() {
        return discountPercent;
    }

    public void setDiscountPercent(double discountPercent) {
        this.discountPercent = discountPercent;
    }

    public void setQuanlytiOfSize(int quanlytiOfSize) {
        this.quanlytiOfSize = quanlytiOfSize;
    }

    public String getSizeDescriptions() {
        return sizeDescriptions;
    }

    public void setSizeDescriptions(String size) {
        this.sizeDescriptions = size;
    }

    public int getSizeId() {
        return Integer.parseInt(sizeId);
    }

    public void setSizeId(String sizeId) {
        this.sizeId = sizeId;
    }

    public int getProductId() {
        return productId;
    }

    public void setProductId(int productId) {
        this.productId = productId;
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }



    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public double getTotalPrice() {
        return totalPrice;
    }

    public void setTotalPrice(double totalPrice) {
        this.totalPrice = totalPrice;
    }

    @Override
    public String toString() {
        return "CartPainting{" +
                "productId=" + productId +
                ", productName='" + productName + '\'' +
                ", sizeDescriptions='" + sizeDescriptions + '\'' +
                ", sizeId='" + sizeId + '\'' +
                ", imageUrl='" + imageUrl + '\'' +
                ", quantity=" + quantity +
                ", price=" + price +
                ", totalPrice=" + totalPrice +
                ", quanlytiOfSize=" + quanlytiOfSize +
                ", discountPrice=" + discountPrice +
                ", discountPercent=" + discountPercent +
                '}';
    }


    public void updateQuantityItem(int quantity){
        this.quantity = quantity;
        double total = this.totalPrice = this.price * quantity;
        this.discountPrice = this.totalPrice * (1 - this.discountPercent / 100);

    }

}
