package com.example.web.dao.model;

import java.io.Serializable;

public class PaintingSize  implements Serializable {
    private int idSize;
    private String sizeDescriptions;
    private int quantity;

    public PaintingSize(int idSize,String sizeDescriptions, int quantity) {
        this.idSize = idSize;
        this.sizeDescriptions = sizeDescriptions;
        this.quantity = quantity;
    }
    public PaintingSize(int idSize,String sizeDescriptions) {
        this.idSize = idSize;
        this.sizeDescriptions = sizeDescriptions;
    }
    public PaintingSize(){}

    public int getIdSize() {
        return idSize;
    }

    public void setIdSize(int idSize) {
        this.idSize = idSize;
    }

    public String getSizeDescriptions() {
        return sizeDescriptions;
    }

    public void setSizeDescriptions(String sizeDescriptions) {
        this.sizeDescriptions = sizeDescriptions;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    @Override
    public String toString() {
        return "PaintingSize{" +
                "sizeDescriptions='" + sizeDescriptions + '\'' +
                ", quantity=" + quantity +
                '}';
    }
}
