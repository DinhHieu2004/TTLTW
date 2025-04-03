package com.example.web.controller.admin.UserController;

import com.example.web.dao.model.Permission;
import com.example.web.dao.model.Role;
import com.example.web.dao.model.User;
import com.example.web.service.PermissionService;
import com.example.web.service.RoleService;
import com.example.web.service.UserSerive;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/admin/users")
public class GetListUser extends HttpServlet {
    private UserSerive userSerive = new UserSerive();
    private RoleService roleService = new RoleService();
    private PermissionService permissionService= new PermissionService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            List<User> users = userSerive.getListUser();
            List<Role> roles = roleService.getAllRoles();
            List<Permission> permissions = permissionService.getAll();
            req.setAttribute("users", users);
            req.setAttribute("roles", roles);
            req.setAttribute("permissions", permissions);
            System.out.println("roles:"+ roles);
            System.out.println("per:"+ permissions);


            req.getRequestDispatcher("users.jsp").forward(req, resp);
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }
}
