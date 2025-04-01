package com.example.web.dao;

import com.example.web.dao.db.DbConnect;
import com.example.web.dao.model.Permission;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.HashSet;
import java.util.Set;

public class PermissionDao {
    Connection conn = DbConnect.getConnection();

       public Permission getPermissionById(int permissionId) throws SQLException {
           String query = "SELECT p.id, p.name " +
                   "FROM permissions p " +
                   "WHERE p.id = ?";
           PreparedStatement stmt = conn.prepareStatement(query);
           stmt.setInt(1, permissionId);
           ResultSet rs = stmt.executeQuery();


           String permissionName = null;

           while (rs.next()) {
               permissionName = rs.getString("name");
              // allowedApis.add(rs.getString("apiPrefix"));
           }

           return new Permission(permissionId, permissionName);

   }
    public Set<Permission> getPermissionsByRoleId(int roleId) throws SQLException {
        String query = "SELECT rp.permissionId FROM role_permissions rp WHERE rp.roleId = ?";
        PreparedStatement stmt = conn.prepareStatement(query);
        stmt.setInt(1, roleId);
        ResultSet rs = stmt.executeQuery();

        Set<Permission> permissions = new HashSet<>();
        while (rs.next()) {
            int permissionId = rs.getInt("permissionId");
            permissions.add(getPermissionById(permissionId));
        }
        return permissions;
    }

    public static void main(String[] args) throws SQLException {
           PermissionDao dao = new PermissionDao();
        System.out.println(dao.getPermissionsByRoleId(1));
    }


}
