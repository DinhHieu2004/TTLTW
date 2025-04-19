package com.example.web.dao.model;

import java.sql.Timestamp;

public class UserVoucher {
    private int id;
    private int userId;
    private int voucherId;
    private boolean isUsed;
    private Timestamp assignedAt;
    private Voucher voucher;

    public UserVoucher(int id, int userId, int voucherId, boolean isUsed, Timestamp assignedAt, Voucher voucher) {
        this.id = id;
        this.userId = userId;
        this.voucherId = voucherId;
        this.isUsed = isUsed;
        this.assignedAt = assignedAt;
        this.voucher = voucher;
    }

    public UserVoucher() {
    }

    public Voucher getVoucher() {
        return voucher;
    }

    public void setVoucher(Voucher voucher) {
        this.voucher = voucher;
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

    public int getVoucherId() {
        return voucherId;
    }

    public void setVoucherId(int voucherId) {
        this.voucherId = voucherId;
    }



    public boolean getIsUsed() {
        return isUsed;
    }

    public void setUsed(boolean used) {
        isUsed = used;
    }

    public Timestamp getAssignedAt() {
        return assignedAt;
    }

    public void setAssignedAt(Timestamp assignedAt) {
        this.assignedAt = assignedAt;
    }
}
