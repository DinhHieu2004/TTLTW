package com.example.web.service;
import com.example.web.dao.UserDao;
import com.example.web.dao.model.User;
import com.example.web.dao.model.UserToken;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.sql.SQLException;

import java.sql.SQLException;
import java.util.UUID;

public class AuthService {
    private UserDao udao = new UserDao();
    private final EmailService emailService = new EmailService();
    public User checkLogin(String username, String pass) throws SQLException {
        User u = udao.findUser(username);
        if(u==null) return null;
        String hashedPassword = hashPassword(pass);
        if (hashedPassword.equals(u.getPassword())) {
            return u;
        }
        return null;
    }
    public boolean registerUser(String fullName, String username, String password, String email, String phone, String role) throws SQLException {
        if (!udao.registerUser(fullName, username, hashPassword(password), email, phone, role)) {
            return false;
        }
        User user = udao.findByEmail(email);
        if (user != null) {
            String token = UUID.randomUUID().toString();
            udao.saveTokenForRegister(user.getId(), token, "register");

            String subject = "Xác nhận email đăng ký";
            String body = "Xin chào " + fullName + ",\n\nCó phải bạn vừa đăng ký tài khoản? " +
                    "Nếu đúng, vui lòng nhấp vào liên kết dưới đây để xác nhận email của bạn và hoàn tất quá trình đăng ký:\n\n"
                    + "http://localhost:8080/TTLTW_war/activate_account?token=" + token + "\n\n"
                    + "Nếu bạn không thực hiện đăng ký này, vui lòng bỏ qua email này.";
            emailService.sendEmail(email, subject, body);
            return true;
        }
        return false;
    }
    public UserToken findByToken(String token, String type) throws SQLException {
        return udao.findByToken(token, type);
    }
    public User findById(int userId) throws SQLException {
        return udao.getUser(userId);
    }
    public boolean activateUserByToken(String token) {
        return udao.activateUserByToken(token);
    }
    public void resendToken(User user, String token) {
        udao.updateTokenForRegister(user.getId(), token);
        String subject = "Gửi lại email xác nhận";
        String body = "Xin chào " + user.getFullName() + ",\n\nCó phải bạn vừa yêu cầu lại liên kết kích hoạt? " +
                "Nếu đúng, vui lòng nhấp vào liên kết dưới đây để xác nhận email của bạn và hoàn tất quá trình đăng ký:\n\n"
                + "http://localhost:8080/TTLTW_war/activate_account?token=" + token + "\n\n"
                + "Nếu không phải bạn, vui lòng bỏ qua email này.";
        emailService.sendEmail(user.getEmail(), subject, body);
    }
    public boolean createUserByGoogle(String gg_id, String name, String email) throws SQLException {
        return udao.createUserByGoogle(gg_id, name, email, 2);
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

    public User findGoogleUserById(String ggId) throws SQLException {
        User u =  udao.findGoogleUserById(ggId);
        if(u != null){
            return u;
        }
        return null;
    }

    public User findFacebookUserById(String fbId) throws SQLException {
        User u =  udao.findFBUserById(fbId);
        if(u != null){
            return u;
        }
        return null;
    }

    public boolean createUserByFacebook(String fbId, String name, String email) throws SQLException {
        return udao.createUserByFB(fbId, name, email, 2);
    }

    public User findUserByEmail(String email) throws SQLException {
        return udao.findByEmail(email);
    }

    public boolean updateUserInfo(User user) throws SQLException {
        return udao.updateUserInfo(user);
    }

    public static void main(String[] args) throws SQLException {
        AuthService a = new AuthService();
        System.out.println(a.checkLogin("admin", "462004"));
    }

    public boolean hasValidToken(User user, String type) {
        return udao.hasValidToken(user, type);
    }

    public boolean passwordRecovery(String email) throws SQLException {
        return udao.passwordRecovery(email);
    }
}
