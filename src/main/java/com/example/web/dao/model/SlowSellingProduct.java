package com.example.web.dao.model;


public class SlowSellingProduct {
    private int paintingId;
    private String title;
    private int sizeId;
    private String sizeDescription;
    private int displayQuantity;
    private double avgDailySale;

    // Getters and setters
    public int getPaintingId() { return paintingId; }
    public void setPaintingId(int paintingId) { this.paintingId = paintingId; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public int getSizeId() { return sizeId; }
    public void setSizeId(int sizeId) { this.sizeId = sizeId; }

    public String getSizeDescription() { return sizeDescription; }
    public void setSizeDescription(String sizeDescription) { this.sizeDescription = sizeDescription; }

    public int getDisplayQuantity() { return displayQuantity; }
    public void setDisplayQuantity(int displayQuantity) { this.displayQuantity = displayQuantity; }

    public double getAvgDailySale() { return avgDailySale; }
    public void setAvgDailySale(double avgDailySale) { this.avgDailySale = avgDailySale; }

    @Override
    public String toString() {
        return "SlowSellingProduct{" +
                "paintingId=" + paintingId +
                ", title='" + title + '\'' +
                ", sizeId=" + sizeId +
                ", sizeDescription='" + sizeDescription + '\'' +
                ", displayQuantity=" + displayQuantity +
                ", avgDailySale=" + avgDailySale +
                '}';
    }
}
