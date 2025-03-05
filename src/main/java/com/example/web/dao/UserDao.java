package com.example.web.dao;

import com.example.web.dao.db.DbConnect;
import com.example.web.dao.model.Artist;
import com.example.web.dao.model.User;


import javax.mail.*;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Properties;
import java.util.UUID;


public class UserDao {
    Connection conn = DbConnect.getConnection();




    public List<User> getListUser() throws SQLException {
        List<User> users = new ArrayList<>();
        String sql = "select * from users";
        PreparedStatement ps = conn.prepareStatement(sql);
        ResultSet rs = ps.executeQuery();

        while (rs.next()) {
            User u = new User();
            u.setId(rs.getInt("id"));
            u.setUsername(rs.getString("username"));
            u.setFullName(rs.getString("fullName"));
            u.setEmail(rs.getString("email"));
            User.Role role = User.Role.valueOf(rs.getString("role"));
            u.setRole(role);
            u.setAddress(rs.getString("address"));
            u.setPhone(rs.getString("phone"));
            users.add(u);
        }
        return users;

    }
    public User getUser(int id) throws SQLException {
        String sql = "select * from users where id=?";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setInt(1, id);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            User u = new User();
            u.setId(rs.getInt("id"));
            u.setUsername(rs.getString("username"));
            u.setFullName(rs.getString("fullName"));
            u.setEmail(rs.getString("email"));
            u.setRole(User.Role.valueOf(rs.getString("role")));
            u.setAddress(rs.getString("address"));
            u.setPhone(rs.getString("phone"));
            u.setPassword(rs.getString("password"));
            return u;
        }
        return null;
    }

    public boolean deleteUser(int i) {
        String query = "DELETE FROM users WHERE id = ?";
        try (PreparedStatement preparedStatement = conn.prepareStatement(query)) {
            preparedStatement.setInt(1, i);
            int rowsAffected = preparedStatement.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }

    }
    public boolean updateUser(User user) throws SQLException {
        String hashedPassword = hashPassword(user.getPassword());

        String updateQuery = "UPDATE users SET fullname = ?, username = ?, password = ?, address = ?, email = ? , phone = ?, role =? WHERE id = ?";
        PreparedStatement statement = conn.prepareStatement(updateQuery);

        statement.setString(1, user.getFullName());
        statement.setString(2, user.getUsername());
        statement.setString(3, hashedPassword);
        statement.setString(4, user.getAddress());
        statement.setString(5, user.getEmail());
        statement.setString(6, user.getPhone());
        statement.setString(7, user.getRole().toString());
        statement.setInt(8, user.getId());
        int rowsAffected = statement.executeUpdate();

        return rowsAffected > 0;

    }

    public User findByUsername(String username) throws SQLException {
        String sql = "SELECT * FROM users WHERE username = ?";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setString(1, username);
        try (ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                int id = rs.getInt("id");
                String fullName = rs.getString("fullName");
                String uname = rs.getString("username");
                String address = rs.getString("address");
                String email = rs.getString("email");
                String phone = rs.getString("phone");
                User.Role role = User.Role.valueOf(rs.getString("role"));

                return new User(id, fullName, uname, address, email, phone, role);
            }

        }
        return null;
    }

    public User findByEmail(String email) throws SQLException {
        String sql = "SELECT * FROM users WHERE email = ?";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setString(1, email);
        try (ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                int id = rs.getInt("id");
                String fullName = rs.getString("fullName");
                String uname = rs.getString("username");
                String address = rs.getString("address");
                String uemail = rs.getString("email");
                String phone = rs.getString("phone");
                User.Role role = User.Role.valueOf(rs.getString("role"));

                return new User(id, fullName, uname, address, uemail, phone, role);
            }

        }
        return null;
    }

    //check login
    public User checkLogin(String username, String password) throws SQLException {
        String hashPass = hashPassword(password);
        String sql = "SELECT * FROM users WHERE username = ? AND password = ?";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setString(1, username);
        ps.setString(2, hashPass);
        try (ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                int id = rs.getInt("id");
                String fullName = rs.getString("fullName");
                String uname = rs.getString("username");
                String address = rs.getString("address");
                String email = rs.getString("email");
                String phone = rs.getString("phone");
                User.Role role = User.Role.valueOf(rs.getString("role"));
                return new User(id, fullName, uname, address, email, phone, role);
            }
        }
        return null;

    }

    public boolean registerUser(String fullName, String username, String password, String address, String email, String phone, String role) throws SQLException {
        if (findByUsername(username) != null) {
            return false;
        }

        String hashedPassword = hashPassword(password);
        String sql = "INSERT INTO users (fullName, username, password, address, email, phone, role) VALUES (?, ?, ?, ?, ?, ?, ?)";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setString(1, fullName);
        ps.setString(2, username);
        ps.setString(3, hashedPassword);
        ps.setString(4, address);
        ps.setString(5, email);
        ps.setString(6, phone);
        ps.setString(7, role);

        return ps.executeUpdate() > 0;

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

    public boolean updatePassword(String username, String newPassword) throws SQLException {
        String sql = "UPDATE users SET password = ? WHERE username = ?";
        String hashedPassword = hashPassword(newPassword);
             PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, hashedPassword);
            ps.setString(2, username);
            return ps.executeUpdate() > 0;

    }


    public static String generateRandomString(int length) {
        // Biến cục bộ chỉ tồn tại trong hàm này
        String characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
        StringBuilder result = new StringBuilder();
        java.util.Random random = new java.util.Random();

        for (int i = 0; i < length; i++) {
            int index = random.nextInt(characters.length());
            result.append(characters.charAt(index));
        }

        return result.toString();
    }


    public boolean updateUserInfo(User user) throws SQLException {
        String query = "UPDATE users SET fullName = ?, phone = ?, email = ?, address = ? WHERE username = ?";
        PreparedStatement ps = conn.prepareStatement(query);
        ps.setString(1, user.getFullName());
        ps.setString(2, user.getPhone());
        ps.setString(3, user.getEmail());
        ps.setString(4, user.getAddress());
        ps.setString(5, user.getUsername());

        return ps.executeUpdate() > 0;

    }

    public static boolean sendMail(String to, String subject, String text) {
        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.ssl.protocols", "TLSv1.2");
        Session session = Session.getInstance(props, new javax.mail.Authenticator() {
            @Override
            protected javax.mail.PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication("shopsandnlu22@gmail.com", "hdfl yops awzj kgxw");
            }
        });
        try {
            Message message = new MimeMessage(session);
            message.setHeader("Content-Type", "text/plain; charset=UTF-8");
            message.setFrom(new InternetAddress("shopsandnlu22@gmail.com"));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to));
            message.setSubject(subject);
            message.setText(text);
            Transport.send(message);
        } catch (MessagingException e) {
            return false;
        }
        return true;
    }

    public boolean passwordRecovery(String email) throws SQLException {
        User user = findByEmail(email); // Tìm người dùng theo email
        if (user == null) {
            return false; // Không tìm thấy người dùng
        }

        // Tạo token ngẫu nhiên
        String token = UUID.randomUUID().toString();

        // Lưu token vào bảng
        String sql = "INSERT INTO password_reset_tokens (user_id, token) VALUES (?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, user.getId());
            ps.setString(2, token);
            ps.executeUpdate();
        }

        // Tạo link đổi mật khẩu
        String resetLink = "http://localhost:8080/web_war/user/reset_password?token=" + token;

        // Gửi email
        String subject = "Yêu cầu đặt lại mật khẩu";
        String content = "Chào bạn."
                + " Bạn đã yêu cầu đặt lại mật khẩu. Nhấn vào link bên dưới để đặt lại mật khẩu:"
                +  resetLink
                + ". Nếu bạn không yêu cầu hành động này, hãy bỏ qua email.";

        return sendMail(email, subject, content);
    }

    public int getUserIdByToken(String token) throws SQLException {
        String sql = "SELECT user_id FROM password_reset_tokens WHERE token = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, token);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("user_id");
                }
            }
        }
        return -1; // Không tìm thấy token
    }
    public void deleteToken(String token) throws SQLException {
        String sql = "DELETE FROM password_reset_tokens WHERE token = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, token);
            ps.executeUpdate();
        }
    }


    public String getPasswordByUsername(String username) throws SQLException {
        String sql = "SELECT password FROM users WHERE username = ?";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setString(1, username);
        try (ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getString("password");
            }
        }

        return null; // Không tìm thấy mật khẩu
    }

    public static void main(String[] args) {
        UserDao userDao = new UserDao();
        String testEmail = "lenguyennhathao0807@gmail.com"; // Địa chỉ email bạn muốn kiểm tra

        try {
            // Gọi phương thức passwordRecovery để kiểm tra
            boolean isEmailSent = userDao.passwordRecovery(testEmail);

            if (isEmailSent) {
                System.out.println("Email đã được gửi thành công để đặt lại mật khẩu.");
            } else {
                System.out.println("Không tìm thấy người dùng với email " + testEmail + " hoặc có lỗi xảy ra.");
            }
        } catch (SQLException e) {
            System.out.println("Lỗi khi thực hiện yêu cầu phục hồi mật khẩu: " + e.getMessage());
        }
    }


}
