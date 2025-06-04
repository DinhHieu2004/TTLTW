package com.example.web.controller.admin.UserController;

import com.example.web.controller.util.CheckPermission;
import com.example.web.dao.model.Permission;
import com.example.web.dao.model.Role;
import com.example.web.dao.model.User;
import com.example.web.service.PermissionService;
import com.example.web.service.RoleService;
import com.example.web.service.UserService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/admin/users")
public class GetListUser extends HttpServlet {
    private UserService userService = new UserService();
    private RoleService roleService = new RoleService();
    private PermissionService permissionService= new PermissionService();

    private final String permission = "VIEW_USERS";


    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("user");

        boolean hasPermission = CheckPermission.checkPermission(user, permission, "ADMIN");
        if (!hasPermission) {
            resp.sendRedirect(req.getContextPath() + "/NoPermission.jsp");
            return;
        }
        try {

            List<User> users = userService.getListUser();
            List<User> userIsDelete = userService.getListUserIsDelete();
            List<Role> roles = roleService.getAllRoles();
            List<Permission> permissions = permissionService.getAll();
            req.setAttribute("users", users);
            req.setAttribute("uDelete", userIsDelete);
            req.setAttribute("roles", roles);
            req.setAttribute("permissions", permissions);
         //   System.out.println("roles:"+ roles);
         //   System.out.println("per:"+ permissions);


            req.getRequestDispatcher("users.jsp").forward(req, resp);
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }
}
