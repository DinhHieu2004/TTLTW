package com.example.web.dao.model;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;

public class DiscountCode {
    private int id;
    private String code;
    private String description;
    private int discountPercent;
    private Timestamp startTime;
    private Timestamp endTime;
    private String triggerEvent;
    private boolean isActive;

    // Constructor mặc định
    public DiscountCode() {}

    // Constructor từ ResultSet
    public DiscountCode(ResultSet rs) throws SQLException {
        this.id = rs.getInt("id");
        this.code = rs.getString("code");
        this.description = rs.getString("description");
        this.discountPercent = rs.getInt("discount_percent");
        this.startTime = rs.getTimestamp("start_time");
        this.endTime = rs.getTimestamp("end_time");
        this.triggerEvent = rs.getString("trigger_event");
        this.isActive = rs.getBoolean("is_active");
    }

    // Getter & Setter
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getCode() { return code; }
    public void setCode(String code) { this.code = code; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public int getDiscountPercent() { return discountPercent; }
    public void setDiscountPercent(int discountPercent) { this.discountPercent = discountPercent; }

    public Timestamp getStartTime() { return startTime; }
    public void setStartTime(Timestamp startTime) { this.startTime = startTime; }

    public Timestamp getEndTime() { return endTime; }
    public void setEndTime(Timestamp endTime) { this.endTime = endTime; }

    public String getTriggerEvent() { return triggerEvent; }
    public void setTriggerEvent(String triggerEvent) { this.triggerEvent = triggerEvent; }

    public boolean isActive() { return isActive; }
    public void setActive(boolean active) { isActive = active; }
}
