package com.example.web.service;
import com.example.web.dao.UserDao;
import com.example.web.dao.model.User;

import java.sql.SQLException;

import java.sql.SQLException;

public class AuthService {
    public User checkLogin(String username, String password) throws SQLException {
        UserDao userDao = new UserDao();
        User user = userDao.checkLogin(username, password);
        if (user != null) {
            return user;
        }
       return null;
    }
}
