package com.example.web.dao.model;


import java.util.Date;

public class ProductReview  implements java.io.Serializable {
    private int id;
    private int userId;
    private String userName;
    private int paintingId;
    private int orderItemId;
    private int rating;
    private String comment;
    private Date createdAt;
    private String paintingTitle;

    public ProductReview(int userId, int paintingId, int orderItemId, int rating, String comment) {
        this.userId = userId;
        this.paintingId = paintingId;
        this.orderItemId = orderItemId;
        this.rating = rating;
        this.comment = comment;
    }

    public ProductReview(int userId, int paintingId, int orderItemId, int rating, String comment, String userName) {
        this.userId = userId;
        this.paintingId = paintingId;
        this.orderItemId = orderItemId;
        this.rating = rating;
        this.comment = comment;
        this.userName = userName;
    }


    public String getPaintingTitle() {
        return paintingTitle;
    }

    public void setPaintingTitle(String paintingTitle) {
        this.paintingTitle = paintingTitle;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public ProductReview(){}

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public int getPaintingId() {
        return paintingId;
    }

    public void setPaintingId(int paintingId) {
        this.paintingId = paintingId;
    }

    public int getOrderItemId() {
        return orderItemId;
    }

    public void setOrderItemId(int orderItemId) {
        this.orderItemId = orderItemId;
    }

    public int getRating() {
        return rating;
    }

    public void setRating(int rating) {
        this.rating = rating;
    }

    public String getComment() {
        return comment;
    }

    public void setComment(String comment) {
        this.comment = comment;
    }

    @Override
    public String toString() {
        return "ProductReview{" +
                "id=" + id +
                ", userId=" + userId +
                ", userName='" + userName + '\'' +
                ", paintingId=" + paintingId +
                ", orderItemId=" + orderItemId +
                ", rating=" + rating +
                ", comment='" + comment + '\'' +
                ", createdAt=" + createdAt +
                ", paintingTitle='" + paintingTitle + '\'' +
                '}';
    }
}
