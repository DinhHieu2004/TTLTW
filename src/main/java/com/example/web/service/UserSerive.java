package com.example.web.service;

import com.example.web.dao.UserDao;
import com.example.web.dao.model.User;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.sql.SQLException;
import java.util.List;
import java.util.Set;

public class UserSerive {
    private UserDao userDao =  new UserDao();
    public boolean registerUser(String fullName, String username, String password, String email, String phone, String role) throws SQLException {
        return userDao.registerUser(fullName, username, hashPassword(password), email, phone, role);
    }
    public  boolean deleteUser(int i) {
        return userDao.deleteUser(i);
    }
    public boolean updateUser(User user, Set<Integer> roleIds) throws SQLException {
        return  userDao.updateUser(user, roleIds);
    }

    public List<User> getListUser() throws SQLException {
        return userDao.getListUser();
    }
    public User getUser(int i) throws SQLException {
        return userDao.getUser(i);
    }



    public User findByUsername(String username) throws SQLException {
        return userDao.findByUsername(username);
    }
    public User findById(int id) throws SQLException {
        return userDao.getUser(id);
    }
    public User findByEmail(String email) throws  SQLException {
        return userDao.findByEmail(email);
    }
    public String hashPassword(String password) {
        try {
            MessageDigest md = MessageDigest.getInstance("MD5");
            byte[] hash = md.digest(password.getBytes());

            StringBuilder hexString = new StringBuilder();
            for (byte b : hash) {
                String hex = Integer.toHexString(0xff & b);
                if (hex.length() == 1) {
                    hexString.append('0');
                }
                hexString.append(hex);
            }

            return hexString.toString();
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException("Error while hashing password with MD5", e);
        }
    }

    public boolean updateUserInfo(User currentUser) throws SQLException {
        return userDao.updateUserInfo(currentUser);
    }

    public boolean addUser(String fullName, String username, String password, String email, String phone, String role, String address) throws SQLException {
        return userDao.addUser(fullName, username, hashPassword(password), email, phone, role, address);
    }

    public static void main(String[] args) throws SQLException {
        UserSerive userSerive = new UserSerive();
        User user = userSerive.findById(4);
        System.out.println(user.getAllRolePermission());
    }
}
