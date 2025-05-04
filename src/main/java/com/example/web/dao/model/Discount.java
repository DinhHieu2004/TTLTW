package com.example.web.dao.model;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

public class Discount {
    private int id;
    private String imageUrl;
    private String imageUrlCloud;
    private String discountName;
    private BigDecimal discountPercentage;
    private LocalDate startDate;
    private LocalDate endDate;
    private LocalDateTime createdAt;

    public Discount() {}

    public Discount(int id, String imageUrl, String imageUrlCloud, String discountName, BigDecimal discountPercentage, LocalDate startDate,
                    LocalDate endDate, LocalDateTime createdAt) {
        this.id = id;
        this.imageUrl = imageUrl;
        this.imageUrlCloud = imageUrlCloud;
        this.discountName = discountName;
        this.discountPercentage = discountPercentage;
        this.startDate = startDate;
        this.endDate = endDate;
        this.createdAt = createdAt;
    }

    // Getter và Setter
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public String getImageUrlCloud() {
        return imageUrlCloud;
    }

    public void setImageUrlCloud(String imageUrlCloud) {
        this.imageUrlCloud = imageUrlCloud;
    }

    public String getDiscountName() {
        return discountName;
    }

    public void setDiscountName(String discountName) {
        this.discountName = discountName;
    }

    public BigDecimal getDiscountPercentage() {
        return discountPercentage;
    }

    public void setDiscountPercentage(BigDecimal discountPercentage) {
        // Kiểm tra giá trị % hợp lệ
        if (discountPercentage.compareTo(BigDecimal.ZERO) < 0 || discountPercentage.compareTo(new BigDecimal("100")) > 0) {
            throw new IllegalArgumentException("Discount percentage must be between 0 and 100.");
        }
        this.discountPercentage = discountPercentage;
    }

    public LocalDate getStartDate() {
        return startDate;
    }

    public void setStartDate(LocalDate startDate) {
        this.startDate = startDate;
    }

    public LocalDate getEndDate() {
        return endDate;
    }

    public void setEndDate(LocalDate endDate) {
        this.endDate = endDate;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    @Override
    public String toString() {
        return "Discount{" +
                "id=" + id +
                ", imageUrl='" + imageUrl + '\'' +
                ", imageUrlCloud='" + imageUrlCloud + '\'' +
                ", discountName='" + discountName + '\'' +
                ", discountPercentage=" + discountPercentage +
                ", startDate=" + startDate +
                ", endDate=" + endDate +
                ", createdAt=" + createdAt +
                '}';
    }
}

