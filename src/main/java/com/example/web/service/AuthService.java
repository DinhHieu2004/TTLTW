package com.example.web.service;
import com.example.web.dao.UserDao;
import com.example.web.dao.model.User;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.sql.SQLException;

import java.sql.SQLException;

public class AuthService {
    private UserDao udao = new UserDao();
    public User checkLogin(String username, String pass) throws SQLException {
        User u = udao.findUser(username);
        if(u==null) return null;
        String hashedPassword = hashPassword(pass);
        if (hashedPassword.equals(u.getPassword())) {
            return u;
        }
        return null;
    }
    public boolean registerUser(String fullName, String username, String password, String address, String email, String phone, String role) throws SQLException {
        return udao.registerUser(fullName, username, hashPassword(password), address, email, phone, role);
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

            return hexString.toString(); // Trả về chuỗi mã hóa MD5
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException("Error while hashing password with MD5", e);
        }
    }
}
