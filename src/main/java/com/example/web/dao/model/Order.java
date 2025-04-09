package com.example.web.dao.model;

import java.io.Serializable;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Date;

public class Order  implements Serializable {
    private int id;
    private int userId;
    private String paymentStatus;
    private String deliveryStatus;
    private double totalAmount;
    private Date orderDate;
    private Date deliveryDate;
    private String recipientName;
    private String deliveryAddress;
    private String recipientPhone;
    private double shippingFee;
    private double priceAfterShipping;
    private String paymentMethod;
    private String vnpTxnRef;


    public double getPriceAfterShipping() {
        return priceAfterShipping;
    }

    public void setPriceAfterShipping(double priceAfterShipping) {
        this.priceAfterShipping = priceAfterShipping;
    }

    public String getRecipientName() {
        return recipientName;
    }

    public void setRecipientName(String recipientName) {
        this.recipientName = recipientName;
    }

    public String getDeliveryAddress() {
        return deliveryAddress;
    }

    public void setDeliveryAddress(String deliveryAddress) {
        this.deliveryAddress = deliveryAddress;
    }

    public String getRecipientPhone() {
        return recipientPhone;
    }

    public void setRecipientPhone(String recipientPhone) {
        this.recipientPhone = recipientPhone;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getPaymentStatus() {
        return paymentStatus;
    }

    public void setPaymentStatus(String paymentStatus) {
        this.paymentStatus = paymentStatus;
    }

    public String getDeliveryStatus() {
        return deliveryStatus;
    }

    public void setDeliveryStatus(String deliveryStatus) {
        this.deliveryStatus = deliveryStatus;
    }

    public double getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(double totalAmount) {
        this.totalAmount = totalAmount;
    }

    public Date getOrderDate() {
        return orderDate;
    }

    public void setOrderDate(Date orderDate) {
        this.orderDate = orderDate;
    }

    public Date getDeliveryDate() {
        return deliveryDate;
    }

    public void setDeliveryDate(Date deliveryDate) {
        this.deliveryDate = deliveryDate;
    }

    public double getShippingFee() {
        return shippingFee;
    }

    public void setShippingFee(double shippingFee) {
        this.shippingFee = shippingFee;
    }

    public String getPaymentMethod() {
        return paymentMethod;
    }

    public void setPaymentMethod(String paymentMethod) {
        this.paymentMethod = paymentMethod;
    }

    public String getVnpTxnRef() {
        return vnpTxnRef;
    }

    public void setVnpTxnRef(String vnpTxnRef) {
        this.vnpTxnRef = vnpTxnRef;
    }

    @Override
    public String toString() {
        return "Order{" +
                "id=" + id +
                ", userId=" + userId +
                ", paymentStatus='" + paymentStatus + '\'' +
                ", deliveryStatus='" + deliveryStatus + '\'' +
                ", totalAmount=" + totalAmount +
                ", orderDate=" + orderDate +
                ", deliveryDate=" + deliveryDate +
                ", recipientName='" + recipientName + '\'' +
                ", deliveryAddress='" + deliveryAddress + '\'' +
                ", recipientPhone='" + recipientPhone + '\'' +
                ", shippingFee=" + shippingFee +
                ", priceAfterShipping=" + priceAfterShipping +
                ", paymentMethod='" + paymentMethod + '\'' +
                ", vnpTxnRef='" + vnpTxnRef + '\'' +
                '}';
    }
}
