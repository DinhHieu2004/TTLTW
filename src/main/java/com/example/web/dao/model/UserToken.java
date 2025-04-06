package com.example.web.dao.model;

import java.sql.Timestamp;
import java.time.LocalDateTime;

public class UserToken {
    private int id;
    private int userId;
    private String token;
    private Timestamp expiredAt;

    public UserToken(int id, int userId, String token, Timestamp expiredAt) {
        this.id = id;
        this.userId = userId;
        this.token = token;
        this.expiredAt = expiredAt;
    }
    public UserToken() {
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

    public String getToken() {
        return token;
    }

    public void setToken(String token) {
        this.token = token;
    }

    public Timestamp getExpiredAt() {
        return expiredAt;
    }

    public void setExpiredAt(Timestamp expiredAt) {
        this.expiredAt = expiredAt;
    }
}
