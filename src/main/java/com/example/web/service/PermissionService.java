package com.example.web.service;

import com.example.web.dao.PermissionDao;
import com.example.web.dao.model.Permission;

import java.sql.SQLException;
import java.util.List;

public class PermissionService {
    private PermissionDao permissionDao= new PermissionDao();

    public List<Permission> getAll() throws SQLException {
        return permissionDao.getAll();
    }
    public static void main(String[] args) throws SQLException {
        PermissionService permissionService = new PermissionService();
        System.out.println(permissionService.getAll());
    }
}
