package com.example.web.dao.model;

import java.util.Date;

public class Voucher implements java.io.Serializable {
    private int id;
    private String name;
    private double discount;
    private boolean isActive;
    private Date createAt;
    private Date startDate;
    private Date endDate;
    private String imageUrl;
    private String imageUrlCloud;
    private String code;
    private String type;

    public Voucher(int id, String name, double discount, boolean isActive, Date createAt, Date startDate, Date endDate, String imageUrl,String imageUrlCloud, String code, String type) {
        this.id = id;
        this.name = name;
        this.discount = discount;
        this.isActive = isActive;
        this.createAt = createAt;
        this.startDate = startDate;
        this.endDate = endDate;
        this.imageUrl = imageUrl;
        this.imageUrlCloud = imageUrlCloud;
        this.code = code;
        this.type = type;
    }
    public Voucher(int id, String name, double discount, boolean isActive, Date startDate, Date endDate) {
        this.id = id;
        this.name = name;
        this.discount = discount;
        this.isActive = isActive;
        this.startDate = startDate;
        this.endDate = endDate;
    }

    public Voucher(String name, double discount, boolean isActive, Date startDate, Date endDate) {
        this.name = name;
        this.discount = discount;
        this.isActive = isActive;
        this.startDate = startDate;
        this.endDate = endDate;
    }


    public Date getStartDate() {
        return startDate;
    }

    public void setStartDate(Date startDate) {
        this.startDate = startDate;
    }

    public Date getEndDate() {
        return endDate;
    }

    public String getImageUrlCloud() {
        return imageUrlCloud;
    }

    public void setImageUrlCloud(String imageUrlCloud) {
        this.imageUrlCloud = imageUrlCloud;
    }

    public void setEndDate(Date endDate) {
        this.endDate = endDate;
    }

    public Voucher() {}

    public int getId() {
        return id;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public double getDiscount() {
        return discount;
    }

    public void setDiscount(double discount) {
        this.discount = discount;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public boolean isActive() {
        return isActive;
    }

    public void setActive(boolean active) {
        isActive = active;
    }

    public Date getCreateAt() {
        return createAt;
    }
    public boolean getIsActive(){
        return isActive;
    }


    public void setCreateAt(Date createAt) {
        this.createAt = createAt;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    @Override
    public String toString() {
        return "Voucher{" +
                "id=" + id +
                ", name='" + name + '\'' +
                ", discount=" + discount +
                ", isActive=" + isActive +
                ", createAt=" + createAt +
                ", startDate=" + startDate +
                ", endDate=" + endDate +
                ", imageUrl='" + imageUrl + '\'' +
                ", code='" + code + '\'' +
                ", type='" + type + '\'' +
                '}';
    }
}
