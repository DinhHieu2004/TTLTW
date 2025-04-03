package com.example.web.controller.admin.RoleController;

import com.example.web.controller.util.GsonProvider;
import com.example.web.dao.model.Role;
import com.example.web.service.RoleService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;


@WebServlet("/admin/roles/detail")
public class Detail extends HttpServlet {

    private RoleService roleService = new RoleService();

    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        int roleId = Integer.parseInt(req.getParameter("roleId"));
        try {

            Role role = roleService.getRoleById(roleId);

            resp.setContentType("application/json");
            resp.setCharacterEncoding("UTF-8");
            resp.getWriter().write(GsonProvider.getGson().toJson(role));
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }




}
