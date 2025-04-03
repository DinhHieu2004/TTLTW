package com.example.web.dao;

import com.example.web.dao.db.DbConnect;
import com.example.web.dao.model.Permission;
import com.example.web.dao.model.Role;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

public class RoleDao {
    Connection conn = DbConnect.getConnection();
    PermissionDao permissionDao = new PermissionDao();

    public Role getRoleById(int roleId) throws SQLException {
        String query = "SELECT name FROM roles WHERE id = ?";
        PreparedStatement stmt = conn.prepareStatement(query);
        stmt.setInt(1, roleId);
        ResultSet rs = stmt.executeQuery();

        if (!rs.next()) return null;
        String roleName = rs.getString("name");

        Set<Permission> permissions = permissionDao.getPermissionsByRoleId(roleId);
        System.out.println(roleName);

        return new Role(roleId, roleName, permissions);
    }

    public Set<Role> getRolesByUserId(int userId) throws SQLException {
        String query = "SELECT ur.roleId FROM user_roles ur WHERE ur.userId = ?";
        PreparedStatement stmt = conn.prepareStatement(query);
        stmt.setInt(1, userId);
        ResultSet rs = stmt.executeQuery();

        Set<Role> roles = new HashSet<>();
        while (rs.next()) {
            int roleId = rs.getInt("roleId");
            roles.add(getRoleById(roleId));
        }
        return roles;
    }

    public static void main(String[] args) throws SQLException {
        RoleDao roleDao = new RoleDao();
       System.out.println(roleDao.getRolesByUserId(2));
      //  System.out.println(roleDao.getRoleById(4));
    }

    public List<Role> getAll() throws SQLException {
        String query = "SELECT * FROM roles";
        List<Role> roles = new ArrayList<>();
        PreparedStatement stmt = conn.prepareStatement(query);
        ResultSet rs = stmt.executeQuery();
        while (rs.next()) {
            int roleId = rs.getInt("id");
            String roleName = rs.getString("name");
            roles.add(new Role(roleId, roleName));

        }
        return roles;
    }
    public boolean updateRoleName(int roleId, String roleName) throws SQLException {
        String sql = "UPDATE roles SET name = ? WHERE id = ?";
             PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, roleName);
            stmt.setInt(2, roleId);

            int rowsUpdated = stmt.executeUpdate();
            return rowsUpdated > 0;
        }


    public boolean updateRolePermissions(int roleId, Set<Integer> permissionIds) throws SQLException {
        String deleteSql = "DELETE FROM role_permissions WHERE roleId = ?";
        String insertSql = "INSERT INTO role_permissions (roleId, permissionId) VALUES (?, ?)";

        PreparedStatement deleteStmt = null;
        PreparedStatement insertStmt = null;

        try {
            deleteStmt = conn.prepareStatement(deleteSql);
            insertStmt = conn.prepareStatement(insertSql);

            conn.setAutoCommit(false);

            deleteStmt.setInt(1, roleId);
            int rowsDeleted = deleteStmt.executeUpdate();

            int rowsInserted = 0;
            for (Integer permissionId : permissionIds) {
                insertStmt.setInt(1, roleId);
                insertStmt.setInt(2, permissionId);
                insertStmt.addBatch();
            }
            int[] batchResult = insertStmt.executeBatch();

            conn.commit();

            for (int result : batchResult) {
                if (result > 0) {
                    rowsInserted++;
                }
            }

            return rowsDeleted > 0 || rowsInserted > 0;

        } catch (SQLException e) {
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException rollbackEx) {
                    rollbackEx.printStackTrace();
                }
            }
            throw e;
        } finally {
            if (deleteStmt != null) {
                try {
                    deleteStmt.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
            if (insertStmt != null) {
                try {
                    insertStmt.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
            // Đặt lại auto-commit
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }
    public Role addRole(Role role) throws SQLException {
        String sql = "INSERT INTO roles (name) VALUES (?)";
        PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);

        pstmt.setString(1, role.getName());
        pstmt.executeUpdate();

        try (ResultSet rs = pstmt.getGeneratedKeys()) {
            if (rs.next()) {
                role.setId(rs.getInt(1));
            }
        }

        return role;
    }
    public boolean addRolePermissions(int roleId, Set<Integer> permissionIds) throws SQLException {
        String sql = "INSERT INTO role_permissions (roleId, permissionId) VALUES (?, ?)";
             PreparedStatement pstmt = conn.prepareStatement(sql);
            for (int permId : permissionIds) {
                pstmt.setInt(1, roleId);
                pstmt.setInt(2, permId);
                pstmt.addBatch();
            }
        int rowsInserted  =pstmt.executeUpdate();
        return rowsInserted > 0;
        }

}
