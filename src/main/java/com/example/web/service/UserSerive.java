package com.example.web.service;

import com.example.web.dao.UserDao;
import com.example.web.dao.model.User;

import java.sql.SQLException;
import java.util.List;

public class UserSerive {
    private UserDao userDao =  new UserDao();

    public  boolean deleteUser(int i) {
        return userDao.deleteUser(i);
    }
    public boolean updateUser(User user) throws SQLException {
        return  userDao.updateUser(user);
    }

    public List<User> getListUser() throws SQLException {
        return userDao.getListUser();
    }
    public User getUser(int i) throws SQLException {
        return userDao.getUser(i);
    }

    public static void main(String[] args) throws SQLException {
        UserSerive userSerive = new UserSerive();
        System.out.println(userSerive.getListUser());
    }
}
