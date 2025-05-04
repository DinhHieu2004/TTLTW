package com.example.web.service;

import com.example.web.controller.util.UserCacheManager;
import com.example.web.dao.UserDao;
import com.example.web.dao.model.User;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.sql.SQLException;
import java.util.List;
import java.util.Set;

public class UserSerive {
    private UserDao userDao =  new UserDao();
    private final UserCacheManager cacheManager = new UserCacheManager();


    public boolean registerUser(String fullName, String username, String password, String email, String phone, String role) throws SQLException {
        return userDao.registerUser(fullName, username, hashPassword(password), email, phone, role);
    }
    public boolean updateUser(User user, Set<Integer> roleIds) throws SQLException {
        boolean result = userDao.updateUser(user, roleIds);
        if (result) {
            cacheManager.invalidateUser(user.getId());
            cacheManager.invalidateAllUsersList();
        }
        return result;
    }


    public boolean deleteUser(int id) {
        boolean result = userDao.deleteUser(id);
        if (result) {
            cacheManager.invalidateUser(id);
        }
        return result;
    }


    public List<User> getListUser() throws SQLException {
        List<User> cachedList = cacheManager.getAllUsers();
        if (cachedList != null) {
            return cachedList;
        }

        List<User> userList = userDao.getListUser();
        cacheManager.putAllUsers(userList);
        return userList;
    }
    public User getUser(int i) throws SQLException {
        return userDao.getUser(i);
    }



    public User findByUsername(String username) throws SQLException {
        return userDao.findByUsername(username);
    }

    public User findById(int id) throws SQLException {
        User cachedUser = cacheManager.getUserById(id);
        if (cachedUser != null) {
            return cachedUser;
        }

        User user = userDao.getUser(id);
        if (user != null) {
            cacheManager.putUser(user);
        }
        return user;
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
        boolean updated = userDao.updateUserInfo(currentUser);
        if (updated) {
            cacheManager.invalidateUser(currentUser.getId());
        }
        return updated;
    }

    public boolean addUser(String fullName, String username, String password, String email, String phone, String role, String address) throws SQLException {
        boolean result = userDao.addUser(fullName, username, hashPassword(password), email, phone, role, address);
        if (result) {
            cacheManager.invalidateAllUsersList();
        }
        return result;
    }


    public static void main(String[] args) throws SQLException {
        UserSerive userSerive = new UserSerive();
        User user = userSerive.findById(4);
        System.out.println(user.getAllRolePermission());
    }
}
