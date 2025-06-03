package com.example.web.service;

import com.example.web.controller.util.UserCacheManager;
import com.example.web.dao.UserDao;
import com.example.web.dao.model.User;
import org.mindrot.jbcrypt.BCrypt;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.sql.SQLException;
import java.util.List;
import java.util.Set;

public class UserService {
    private UserDao userDao =  new UserDao();
    private final UserCacheManager cacheManager = UserCacheManager.getInstance();


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
            cacheManager.invalidateAllUsersList();
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
        return BCrypt.hashpw(password, BCrypt.gensalt(12));
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
    public boolean changePassword(int userId, String pass) throws SQLException {
        User user = userDao.getUser(userId);
        if(user.getPassword() == null){
            return false;
        }
        return userDao.updatePassword(userId, hashPassword(pass));
    }
    public void updateUsersStatusIfTokenExpired() {
        userDao.updateStatusDeletedForExpiredTokens();
    }

    public static void main(String[] args) throws SQLException {
        UserService userService = new UserService();
        User user = userService.findById(4);
        System.out.println(user.getAllRolePermission());
    }

}
