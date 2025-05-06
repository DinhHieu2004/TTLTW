package com.example.web.dao.model;

import java.io.Serializable;

public class PaintingSize  implements Serializable {
    private int idSize;
    private String sizeDescriptions;
    private int quantity;
    private int totalQuantity;
    private int reservedQuantity;
    private Integer displayQuantity;
    private Double weight;

//    public PaintingSize(int idSize,String sizeDescriptions, int quantity, Double weight) {
//        this.idSize = idSize;
//        this.sizeDescriptions = sizeDescriptions;
//        this.quantity = quantity;
//        this.weight = weight;
//    }

    public PaintingSize(int idSize, String sizeDescriptions, int displayQuantity, Double weight) {
        this.idSize = idSize;
        this.sizeDescriptions = sizeDescriptions;
        this.displayQuantity = displayQuantity;
        this.weight = weight;
    }

    public PaintingSize(int idSize, String sizeDescriptions) {
        this.idSize = idSize;
        this.sizeDescriptions = sizeDescriptions;
    }

    public PaintingSize(int idSize, String sizeDescriptions, int totalQuantity, int reservedQuantity, Integer displayQuantity, Double weight) {
        this.idSize = idSize;
        this.sizeDescriptions = sizeDescriptions;
        this.totalQuantity = totalQuantity;
        this.reservedQuantity = reservedQuantity;
        this.displayQuantity = displayQuantity;
        this.weight = weight;
    }

    public PaintingSize(){}

    public int getIdSize() {
        return idSize;
    }

    public void setIdSize(int idSize) {
        this.idSize = idSize;
    }

    public Double getWeight() {
        return weight;
    }

    public void setWeight(Double weight) {
        this.weight = weight;
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

    public int getTotalQuantity() {
        return totalQuantity;
    }

    public void setTotalQuantity(int totalQuantity) {
        this.totalQuantity = totalQuantity;
    }

    public int getReservedQuantity() {
        return reservedQuantity;
    }

    public void setReservedQuantity(int reservedQuantity) {
        this.reservedQuantity = reservedQuantity;
    }

    public Integer getDisplayQuantity() {
        return displayQuantity;
    }

    public void setDisplayQuantity(Integer displayQuantity) {
        this.displayQuantity = displayQuantity;
    }

    @Override
    public String toString() {
        return "PaintingSize{" +
                "idSize=" + idSize +
                ", sizeDescriptions='" + sizeDescriptions + '\'' +
                ", quantity=" + quantity +
                ", weight=" + weight +
                '}';
    }
}
