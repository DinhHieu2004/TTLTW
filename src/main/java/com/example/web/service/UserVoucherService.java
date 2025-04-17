package com.example.web.service;

import com.example.web.dao.UserVoucherDao;
import com.example.web.dao.model.UserVoucher;
import java.sql.SQLException;
import java.util.List;

public class UserVoucherService {
    UserVoucherDao userVoucherDao = new UserVoucherDao();

    public List<UserVoucher> getAllByUserId(int userId) throws SQLException {
        return userVoucherDao.getUserVoucherById(userId);
    }

    public List<UserVoucher> getUnusedVouchersByUser(int userId) throws SQLException {
        return userVoucherDao.getUnusedVouchersByUser(userId);
    }

    public boolean assignVoucher(int userId, int voucherId) throws SQLException {
        return userVoucherDao.assignVoucherToUser(userId, voucherId);
    }

    public boolean markAsUsed(int voucherId, int userId) throws SQLException {
        return userVoucherDao.markVoucherAsUsed(voucherId, userId);
    }
}

