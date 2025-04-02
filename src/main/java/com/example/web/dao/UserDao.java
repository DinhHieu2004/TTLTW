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
        String updateQuery = "UPDATE users SET fullname = ?, username = ?, address = ?, email = ? , phone = ?, role =? WHERE id = ?";
        PreparedStatement statement = conn.prepareStatement(updateQuery);

        statement.setString(1, user.getFullName());
        statement.setString(2, user.getUsername());
        statement.setString(3, user.getAddress());
        statement.setString(4, user.getEmail());
        statement.setString(5, user.getPhone());
        statement.setString(6, user.getRole().toString());
        statement.setInt(7, user.getId());
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
    public User findUser(String username) throws SQLException {
        String sql = "SELECT * FROM users WHERE username = ?";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setString(1, username);
        try (ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                int id = rs.getInt("id");
                String fullName = rs.getString("fullName");
                String uname = rs.getString("username");
                String address = rs.getString("address");
                String email = rs.getString("email");
                String phone = rs.getString("phone");
                String password = rs.getString("password");
                User.Role role = User.Role.valueOf(rs.getString("role"));
                return new User(id, fullName, uname, address, email, phone, role, password);
            }
        }
        return null;

    }

    public boolean registerUser(String fullName, String username, String hashPassword, String email, String phone, String role) throws SQLException {
        if (findByUsername(username) != null) {
            return false;
        }
        String sql;
        if (phone != null) {
            sql = "INSERT INTO users (fullName, username, password, email, role, phone) VALUES (?, ?, ?, ?, ?, ?)";
        } else {
            sql = "INSERT INTO users (fullName, username, password, email, role) VALUES (?, ?, ?, ?, ?)";
        }

        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setString(1, fullName);
        ps.setString(2, username);
        ps.setString(3, hashPassword);
        ps.setString(4, email);
        ps.setString(5, role);

        if (phone != null) {
            ps.setString(6, phone);
        }

        return ps.executeUpdate() > 0;
    }
    public boolean addUser(String fullName, String username, String hashPassword, String email, String phone, String role, String address) throws SQLException {
        if (findByUsername(username) != null) {
            return false;
        }

        StringBuilder sql = new StringBuilder("INSERT INTO users (fullName, username, password, email, role");
        StringBuilder values = new StringBuilder(" VALUES (?, ?, ?, ?, ?");
        List<Object> params = new ArrayList<>();

        params.add(fullName);
        params.add(username);
        params.add(hashPassword);
        params.add(email);
        params.add(role);

        if (phone != null) {
            sql.append(", phone");
            values.append(", ?");
            params.add(phone);
        }

        if (address != null) {
            sql.append(", address");
            values.append(", ?");
            params.add(address);
        }

        sql.append(")").append(values).append(")");

        PreparedStatement ps = conn.prepareStatement(sql.toString());

        for (int i = 0; i < params.size(); i++) {
            ps.setObject(i + 1, params.get(i));
        }

        return ps.executeUpdate() > 0;
    }

    public boolean updatePassword(String username, String hashPassword) throws SQLException {
        String sql = "UPDATE users SET password = ? WHERE username = ?";
             PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, hashPassword);
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
    public boolean createUserByGoogle(String id, String name, String email, String role) throws SQLException {
        User existingUser = findGoogleUserById(id);
        if (existingUser != null) {
            return false;
        }
        String sql = "INSERT INTO users (fullName, email, gg_id, role) VALUES (?, ?, ?, ?)";

        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setString(1, name);
        ps.setString(2, email);
        ps.setString(3, id);
        ps.setString(4, role);


        return ps.executeUpdate() > 0;
    }

    public User findGoogleUserById(String gg_id) throws SQLException {
        String sql = "SELECT * FROM users WHERE gg_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, gg_id);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new User(
                            rs.getInt("id"),
                            rs.getString("gg_id"),
                            rs.getString("fb_id"),
                            rs.getString("fullName"),
                            rs.getString("email"),
                            User.Role.valueOf(rs.getString("role"))
                    );
                }
            }
        }
        return null;
    }
    public boolean createUserByFB(String fbId, String name, String email, String role) throws SQLException {
        User existingUser = findFBUserById(fbId);
        if (existingUser != null) {
            return false;
        }
        String sql = "INSERT INTO users (fullName, email, fb_id, role) VALUES (?, ?, ?, ?)";

        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setString(1, name);
        ps.setString(2, email);
        ps.setString(3, fbId);
        ps.setString(4, role);


        return ps.executeUpdate() > 0;
    }
    public User findFBUserById(String fbId) throws SQLException {
        String sql = "SELECT * FROM users WHERE fb_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, fbId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new User(
                            rs.getInt("id"),
                            rs.getString("gg_id"),
                            rs.getString("fb_id"),
                            rs.getString("fullName"),
                            rs.getString("email"),
                            User.Role.valueOf(rs.getString("role"))
                    );
                }
            }
        }
        return null;
    }

    public static void main(String[] args) {
        UserDao userDao = new UserDao();
        String testEmail = ""; // Địa chỉ email bạn muốn kiểm tra

        try {
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
