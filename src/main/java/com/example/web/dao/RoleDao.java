package com.example.web.dao;

import com.example.web.dao.db.DbConnect;
import com.example.web.dao.model.Permission;
import com.example.web.dao.model.Role;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.HashSet;
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
}
