package com.example.web.service;
import com.example.web.dao.UserDao;
import com.example.web.dao.model.User;
import com.example.web.dao.model.UserToken;
import org.mindrot.jbcrypt.BCrypt;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.sql.SQLException;

import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.UUID;

public class AuthService {
    private UserDao udao = new UserDao();
    private final EmailService emailService = new EmailService();
    public User checkLogin(String username, String pass) throws SQLException {
        User u = udao.findUser(username);
        if (u == null) return null;
        String hashedPasswordFromDB = u.getPassword();
        if (BCrypt.checkpw(pass, hashedPasswordFromDB)) {
            return u;
        }
        return null;
    }
    public boolean registerUser(String fullName, String username, String password, String email, String phone, String role) throws SQLException {
        if (!udao.registerUser(fullName, username, hashPassword(password), email, phone, role)) {
            return false;
        }
        User user = udao.findByEmail(email);
        long time = 24 * 60 * 60 * 1000;
        if (user != null) {
            String token = UUID.randomUUID().toString();
            udao.saveTokens(user.getId(), token, "register", time);

            String subject = "Xác nhận email đăng ký";
            String body = "Xin chào " + fullName + ",\n\nCó phải bạn vừa đăng ký tài khoản? " +
                    "Nếu đúng, vui lòng nhấp vào liên kết dưới đây để xác nhận email của bạn và hoàn tất quá trình đăng ký:\n\n"
                    + "http://localhost:8080/TTLTW_war/activate_account?token=" + token + "\n\n"
                    + "Nếu bạn không thực hiện đăng ký này, vui lòng bỏ qua email này.";
            return  emailService.sendEmail(email, subject, body);
        }
        return false;
    }
    public UserToken findByToken(String token, String type) throws SQLException {
        return udao.findByToken(token, type);
    }
    public User findById(int userId) throws SQLException {
        return udao.getUser(userId);
    }
    public boolean activateUserByToken(String token, int userId) {
        return udao.activateUserByToken(token, userId);
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
    public boolean hasValidToken(User user, String type) {
        return udao.hasValidToken(user, type);
    }

    public boolean passwordRecovery(String email) throws SQLException {
        User user = udao.findByEmail(email);
        if (user == null || user.getPassword() == null || user.getPassword().isEmpty() || !user.getStatus().equals("Hoạt động")) {
            return false;
        }
        long time = 15 * 60 * 1000;

        String token = UUID.randomUUID().toString();
        udao.deleteActiveTokens(user.getId(), "forgotPass");
        udao.saveTokens(user.getId(), token, "forgotPass", time);

        String resetLink = "http://localhost:8080/TTLTW_war/reset_password?token=" + token;

        String subject = "Yêu cầu đặt lại mật khẩu";
        String body = "Chào bạn,\n\n"
                + "Bạn đã yêu cầu đặt lại mật khẩu. Nhấn vào link bên dưới để đặt lại mật khẩu:\n"
                + resetLink + "\n\n"
                + "Nếu bạn không yêu cầu hành động này, vui lòng bỏ qua email.";

        return emailService.sendEmail(user.getEmail(), subject, body);
    }
    public boolean createUserByGoogle(String gg_id, String name, String email) throws SQLException {
        return udao.createUserByGoogle(gg_id, name, email, 2);
    }
    public String hashPassword(String password) {
        return BCrypt.hashpw(password, BCrypt.gensalt(12));
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
    public String handleResetPassword(String token, String newPassword) throws SQLException {
        UserToken userToken = findByToken(token, "forgotPass");

        if (userToken == null || userToken.getExpiredAt().before(new Timestamp(System.currentTimeMillis()))) {
            return "token_expired";
        }
        User user = udao.getUser(userToken.getUserId());
        if (user == null) {
            return "token_expired";
        }
        String hashedNewPassword = hashPassword(newPassword);

        if (hashedNewPassword.equals(user.getPassword())) {
            return "same_password";
        }
        boolean updated = udao.updatePassword(user.getId(), hashedNewPassword);

        if (updated) {
            udao.deleteRegisterToken(token, "forgotPass");
            return "success";
        } else {
            return "update_failed";
        }
    }

    public static void main(String[] args) throws SQLException {
        AuthService a = new AuthService();
        System.out.println(a.checkLogin("admin", "462004"));
    }
}
