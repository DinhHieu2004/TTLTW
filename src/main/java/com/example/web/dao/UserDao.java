package com.example.web.dao;

import com.example.web.dao.db.DbConnect;
import com.example.web.dao.model.Artist;
import com.example.web.dao.model.Role;
import com.example.web.dao.model.User;
import com.example.web.dao.model.UserToken;


import javax.mail.*;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.sql.*;
import java.util.*;


public class UserDao {
    Connection conn = DbConnect.getConnection();
    RoleDao roleDao = new RoleDao();

    public List<User> getListUser() throws SQLException {
        List<User> users = new ArrayList<>();
        String sql = "select * from users WHERE status NOT IN ('Đã xóa')";
        PreparedStatement ps = conn.prepareStatement(sql);
        ResultSet rs = ps.executeQuery();

        while (rs.next()) {
            User u = new User();
            u.setId(rs.getInt("id"));
            u.setUsername(rs.getString("username"));
            u.setFullName(rs.getString("fullName"));
            u.setEmail(rs.getString("email"));
            Set<Role> roles = roleDao.getRolesByUserId(u.getId());
            u.setRole(roles);
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
            Set<Role> roles = roleDao.getRolesByUserId(u.getId());
            u.setRole(roles);
            u.setAddress(rs.getString("address"));
            u.setPhone(rs.getString("phone"));
            u.setPassword(rs.getString("password"));
            u.setStatus(rs.getString("status"));
            return u;
        }
        return null;
    }

    public boolean deleteUser(int i) {
        String query = "UPDATE users SET status = ? WHERE id = ?";
        try (PreparedStatement preparedStatement = conn.prepareStatement(query)) {
            preparedStatement.setString(1, "Đã xóa");
            preparedStatement.setInt(2, i);
            int rowsAffected = preparedStatement.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }

    }
    public void deleteAccountCus(Connection conn, int id) {
        String query = "UPDATE users SET status = ? WHERE id = ?";
        try (PreparedStatement preparedStatement = conn.prepareStatement(query)) {
            preparedStatement.setString(1, "Chờ xóa");
            preparedStatement.setInt(2, id);
            int rowsUpdated = preparedStatement.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    public boolean updateUser(User user, Set<Integer> roleIds) throws SQLException {
        PreparedStatement statement = null;
        boolean success = false;

        try {
            conn.setAutoCommit(false);

            String updateUserQuery = "UPDATE users SET fullname = ?, username = ?, address = ?, email = ?, phone = ?, status = ? WHERE id = ?";
            statement = conn.prepareStatement(updateUserQuery);

            statement.setString(1, user.getFullName());
            statement.setString(2, user.getUsername());
            statement.setString(3, user.getAddress());
            statement.setString(4, user.getEmail());
            statement.setString(5, user.getPhone());
            statement.setString(5, user.getPhone());
            statement.setString(6, user.getStatus());
            statement.setInt(7, user.getId());

            int rowsAffected = statement.executeUpdate();
            success = rowsAffected > 0;

            if (roleIds != null) {
                String deleteRolesQuery = "DELETE FROM user_roles WHERE userId = ?";
                statement = conn.prepareStatement(deleteRolesQuery);
                statement.setInt(1, user.getId());
                statement.executeUpdate();

                if (!roleIds.isEmpty()) {
                    String insertRolesQuery = "INSERT INTO user_roles (userId, roleId) VALUES (?, ?)";
                    statement = conn.prepareStatement(insertRolesQuery);

                    for (Integer roleId : roleIds) {
                        statement.setInt(1, user.getId());
                        statement.setInt(2, roleId);
                        statement.addBatch();
                    }
                    statement.executeBatch();
                }
            }

            conn.commit();
            return success;

        } catch (SQLException e) {
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException rollbackEx) {
                    rollbackEx.printStackTrace();
                }
            }
            throw e;
        }
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
                String password = rs.getString("password");
                Set<Role> roles = roleDao.getRolesByUserId(id);
                String status = rs.getString("status");
                return new User(id, fullName, uname, address, email, phone, password, roles, status);
            }

        }
        return null;
    }

    public User findByEmail(String email) throws SQLException {
        String sql = "SELECT * FROM users WHERE email = ? AND status NOT IN ('Đã xóa')";
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
                //     User.Role role = User.Role.valueOf(rs.getString("role"));
                String password = rs.getString("password");
                String gg_id = rs.getString("gg_id");
                String fb_id = rs.getString("fb_id");
                Set<Role> roles = roleDao.getRolesByUserId(id);
                String status = rs.getString("status");
                return new User(id, fullName, uname, address, uemail, phone, password, gg_id, fb_id, roles, status);
            }

        }
        return null;
    }

    //check login
    public User findUser(String username) throws SQLException {
        String sql = "SELECT * FROM users WHERE username = ? AND status NOT IN ('Đã xóa', 'Chờ xóa')";
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
                Set<Role> roles = roleDao.getRolesByUserId(id);
                String status = rs.getString("status");
                return new User(id, fullName, uname, address, email, phone, password, roles, status);
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

    public void saveTokens(Connection con,int userId, String token, String type, long expiryMillis) {
        String sql = "INSERT INTO tokens (userId, token, expiredAt, type) VALUES (?, ?, ?, ?)";

        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setString(2, token);
            ps.setTimestamp(3, new java.sql.Timestamp(System.currentTimeMillis() + expiryMillis));
            ps.setString(4, type);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    public void updateTokenForRegister(int userId, String token) {
        String sql = "UPDATE tokens SET token = ?, expiredAt = ? WHERE userId = ? AND type =? ";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, token);
            ps.setTimestamp(2, new java.sql.Timestamp(System.currentTimeMillis() + 24 * 60 * 60 * 1000));
            ps.setInt(3, userId);
            ps.setString(4, "register");

            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }


    public UserToken findByToken(String token, String type) throws SQLException {
        String sql = "SELECT * FROM tokens WHERE token = ? AND type = ?";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setString(1, token);
        ps.setString(2, type);
        try (ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                int id = rs.getInt("id");
                int userId = rs.getInt("userId");
                String tokenStr = rs.getString("token");
                Timestamp expiredAt = rs.getTimestamp("expiredAt");
                String typeToken = rs.getString("type");
                return new UserToken(id, userId, tokenStr, expiredAt, typeToken);
            }
        }
        return null;
    }

    public boolean updateUserStatusByToken(String token, String type) throws SQLException {
        String sqlUpdateUser = "UPDATE users SET status = ? WHERE id = " +
                "(SELECT userId FROM tokens WHERE token = ? AND type = ?)";

        try (PreparedStatement psUpdateUser = conn.prepareStatement(sqlUpdateUser)) {
            psUpdateUser.setString(1, "Hoạt động");
            psUpdateUser.setString(2, token);
            psUpdateUser.setString(3, type);
            int rowsAffected = psUpdateUser.executeUpdate();

            return rowsAffected > 0;
        }
    }
    public boolean deleteToken(String token, String type) throws SQLException {
        String sqlDeleteToken = "DELETE FROM tokens WHERE token = ? AND type = ?";

        try (PreparedStatement psDeleteToken = conn.prepareStatement(sqlDeleteToken)) {
            psDeleteToken.setString(1, token);
            psDeleteToken.setString(2, type);
            int rowsAffected = psDeleteToken.executeUpdate();

            return rowsAffected > 0;
        }
    }
    public boolean activateUserByToken(String token, int userId) {
        try {
            conn.setAutoCommit(false);
            boolean isUserUpdated = updateUserStatusByToken(token, "register");
            if (!isUserUpdated) {
                conn.rollback();
                return false;
            }
            String insertRoleQuery = "INSERT INTO user_roles (userId, roleId) VALUES (?, ?)";
            try (PreparedStatement insertRolePs = conn.prepareStatement(insertRoleQuery)) {
                insertRolePs.setInt(1, userId);
                insertRolePs.setInt(2, 2);
                insertRolePs.executeUpdate();
            }
            boolean isTokenDeleted = deleteToken(token, "register");
            if (!isTokenDeleted) {
                conn.rollback();
                return false;
            }
            conn.commit();
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            try {
                conn.rollback();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
        } finally {
            try {
                conn.setAutoCommit(true);
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return false;
    }
    public boolean undoDeleteUserByToken(String token, int id) {
        try {
            conn.setAutoCommit(false);
            boolean isUserUpdated = updateUserStatusByToken(token, "undoDelete");
            if (!isUserUpdated) {
                conn.rollback();
                return false;
            }
            boolean isTokenDeleted = deleteToken(token, "undoDelete");
            if (!isTokenDeleted) {
                conn.rollback();
                return false;
            }
            conn.commit();
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            try {
                conn.rollback();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
        } finally {
            try {
                conn.setAutoCommit(true);
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return false;
    }
    public boolean hasValidToken(User user, String type) {
        String sql = "SELECT * FROM tokens WHERE userId = ? AND expiredAt > NOW() AND type = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, user.getId());
            ps.setString(2, type);
            ResultSet rs = ps.executeQuery();
            return rs.next();
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    public void deleteActiveTokens(int userId, String type) {
        String sql = "DELETE FROM tokens WHERE userId = ? AND type = ? AND expiredAt > CURRENT_TIMESTAMP";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setString(2, type);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
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

    public boolean updatePassword(int id, String hashPassword) throws SQLException {
        String sql = "UPDATE users SET password = ? WHERE id = ?";
             PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, hashPassword);
            ps.setInt(2, id);
            return ps.executeUpdate() > 0;

    }


    public static String generateRandomString(int length) {
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
        String query = "UPDATE users SET fullName = ?, phone = ?, email = ?, address = ? WHERE id = ?";
        PreparedStatement ps = conn.prepareStatement(query);
        ps.setString(1, user.getFullName());
        ps.setString(2, user.getPhone());
        ps.setString(3, user.getEmail());
        ps.setString(4, user.getAddress());
        ps.setInt(5, user.getId());

        return ps.executeUpdate() > 0;

    }
    public String getPasswordByUsername(String username) throws SQLException {
        String sql = "SELECT password FROM users WHERE username = ? AND status NOT IN ('Đã xóa', 'Chờ xóa')";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setString(1, username);
        try (ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getString("password");
            }
        }

        return null;
    }
    public boolean createUserByGoogle(String id, String name, String email, int role) throws SQLException {
        User existingUser = findGoogleUserById(id);
        if (existingUser != null) {
            return false;
        }
        String sql = "INSERT INTO users (fullName, email, gg_id, status) VALUES (?, ?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, name);
            ps.setString(2, email);
            ps.setString(3, id);
            ps.setString(4, "Hoạt động");

            int affectedRows = ps.executeUpdate();

            if (affectedRows > 0) {
                ResultSet generatedKeys = ps.getGeneratedKeys();
                if (generatedKeys.next()) {
                    int userId = generatedKeys.getInt(1);

                    String insertRoleQuery = "INSERT INTO user_roles (userId, roleId) VALUES (?, ?)";
                    try (PreparedStatement insertRolePs = conn.prepareStatement(insertRoleQuery)) {
                        insertRolePs.setInt(1, userId);
                        insertRolePs.setInt(2, role);
                        insertRolePs.executeUpdate();

                        return true;
                    }
                }
            }

            return false;
        }
    }

    public User findGoogleUserById(String gg_id) throws SQLException {
        String sql = "SELECT * FROM users WHERE gg_id = ? AND status NOT IN ('Đã xóa')";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, gg_id);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    int id = rs.getInt("id");
                    String ggid = rs.getString("gg_id");
                    String name = rs.getString("fullName");
                    String email = rs.getString("email");
                    String fbid = rs.getString("fb_id");
                    Set<Role> roles = roleDao.getRolesByUserId(id);
                    String status = rs.getString("status");

                    return new User(id, ggid,fbid,name, email,roles, status);
                }
            }
        }
        return null;
    }
    public boolean createUserByFB(String fbId, String name, String email, int role) throws SQLException {
        User existingUser = findFBUserById(fbId);
        if (existingUser != null) {
            return false;
        }
        String sql = "INSERT INTO users (fullName, email, fb_id, status) VALUES (?, ?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, name);
            ps.setString(2, email);
            ps.setString(3, fbId);
            ps.setString(4, "Hoạt động");

            int affectedRows = ps.executeUpdate();

            if (affectedRows > 0) {
                ResultSet generatedKeys = ps.getGeneratedKeys();
                if (generatedKeys.next()) {
                    int userId = generatedKeys.getInt(1);

                    String insertRoleQuery = "INSERT INTO user_roles (userId, roleId) VALUES (?, ?)";
                    try (PreparedStatement insertRolePs = conn.prepareStatement(insertRoleQuery)) {
                        insertRolePs.setInt(1, userId);
                        insertRolePs.setInt(2, role);
                        insertRolePs.executeUpdate();

                        return true;
                    }
                }
            }

            return false;
        }
    }
    public User findFBUserById(String fbId) throws SQLException {
        String sql = "SELECT * FROM users WHERE fb_id = ? AND status NOT IN ('Đã xóa')";
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
                            roleDao.getRolesByUserId(rs.getInt("id")),
                            rs.getString("status")
                    );
                }
            }
        }
        return null;
    }

    public List<User> getUsersByRoleId(int roleId) throws SQLException {
        List<User> users = new ArrayList<>();
        String sql =  """
                            SELECT u.*
                            FROM users u
                            JOIN user_roles ur ON u.id = ur.userId
                            WHERE ur.roleId = ?
                        """;
        PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, roleId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                User user = new User();
                user.setId(rs.getInt("id"));
                user.setEmail(rs.getString("email"));
                user.setUsername(rs.getString("username"));
                users.add(user);
            }
        return users;
    }
    public List<User> getListUserIsDelete() throws SQLException {
        List<User> users = new ArrayList<>();
        String sql = "select * from users WHERE status IN ('Đã xóa')";
        PreparedStatement ps = conn.prepareStatement(sql);
        ResultSet rs = ps.executeQuery();

        while (rs.next()) {
            User u = new User();
            u.setId(rs.getInt("id"));
            u.setUsername(rs.getString("username"));
            u.setFullName(rs.getString("fullName"));
            u.setEmail(rs.getString("email"));
            Set<Role> roles = roleDao.getRolesByUserId(u.getId());
            u.setRole(roles);
            u.setAddress(rs.getString("address"));
            u.setPhone(rs.getString("phone"));
            users.add(u);
        }
        return users;

    }
    public void updateStatusDeletedForExpiredTokens() {
        String updateSql = "UPDATE users u " +
                "JOIN tokens t ON u.id = t.userId " +
                "SET u.status = 'Đã xóa' " +
                "WHERE t.type = 'undoDelete' AND t.expiredAt <= NOW()";

        String deleteSql = "DELETE t FROM tokens t " +
                "JOIN users u ON t.userId = u.id " +
                "WHERE t.type = 'undoDelete' AND t.expiredAt <= NOW() AND u.status = 'Đã xóa'";

        try (
                PreparedStatement updatePs = conn.prepareStatement(updateSql);
                PreparedStatement deletePs = conn.prepareStatement(deleteSql)
        ) {
            int updatedRows = updatePs.executeUpdate();
            int deletedRows = deletePs.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public static void main(String[] args) throws SQLException {
        UserDao userDao = new UserDao();
        System.out.println(userDao.getUsersByRoleId(17));
    }
}
