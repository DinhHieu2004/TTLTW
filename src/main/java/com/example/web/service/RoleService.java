package com.example.web.service;

import com.example.web.dao.RoleDao;
import com.example.web.dao.UserDao;
import com.example.web.dao.model.Permission;
import com.example.web.dao.model.Role;
import com.example.web.dao.model.User;
import com.google.common.collect.Sets;

import java.sql.SQLException;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

public class RoleService {
    private final RoleDao roleDao = new RoleDao();
    private final UserDao userDao = new UserDao();

    public List<Role> getAllRoles() throws SQLException {
        return roleDao.getAll();
    }



    public Role getRoleById(int roleId) throws SQLException {
        return roleDao.getRoleById(roleId);
    }

    public boolean updateRole(int roleId, String roleName, Set<Integer> permissionIds) {
        try {
            boolean nameUpdated = roleDao.updateRoleName(roleId, roleName);
            boolean permissionsUpdated = roleDao.updateRolePermissions(roleId, permissionIds); // Điều chỉnh để nhận Set<Integer>

            // Nếu ít nhất một thao tác thành công, trả về true
            return nameUpdated || permissionsUpdated;
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("Lỗi khi cập nhật Role: " + e.getMessage());
        }
    }

    public Role addRoleWithPermissions(Role role, Set<Integer> permissionIds) throws SQLException {
        try {
            Role newRole = roleDao.addRole(role);

            System.out.println("newRole = " + newRole);

            if (permissionIds != null && !permissionIds.isEmpty()) {
                roleDao.addRolePermissions(newRole.getId(), permissionIds);
            }
            return newRole ;
        } catch (SQLException e) {
            throw new SQLException("Error adding role with permissions: " + e.getMessage(), e);
        }
    }

    public boolean deleteRole(int roleId) throws SQLException {
        return roleDao.delete(roleId);
    }

    public static void main(String[] args) throws SQLException {
        Set<Integer> permissionIds = Sets.newHashSet(7, 8, 9);
        RoleService roleService = new RoleService();
        Role role = new Role("ABC");
        System.out.println(roleService.addRoleWithPermissions(role, permissionIds));
    }

    public List<User> getUsersByRoleId(int roleId) throws SQLException {
        return userDao.getUsersByRoleId(roleId);

    }
}
