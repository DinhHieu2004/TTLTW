package com.example.web.controller.admin.RoleController;

import com.example.web.dao.model.Role;
import com.example.web.service.RoleService;
import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Set;

@WebServlet("/admin/roles/add")
public class Add extends HttpServlet {
    private Gson gson = new Gson();
    private RoleService roleService = new RoleService();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String roleName = req.getParameter("roleName");
        String[] permissionIdsArray = req.getParameterValues("permissionIds");

        System.out.println("per: "+ permissionIdsArray);
        System.out.println("rolename: " + roleName);

        Set<Integer> permissionIds = new HashSet<>();
        if (permissionIdsArray != null && permissionIdsArray.length > 0) {
            for (String permissionId : permissionIdsArray) {
                try {
                    permissionIds.add(Integer.parseInt(permissionId));
                } catch (NumberFormatException e) {
                    System.err.println("Invalid permissionId: " + permissionId);
                }
            }
        } else {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "At least one permission must be selected");
            return;
        }

        Role role = new Role(roleName);
        try {
            Role newRole = roleService.addRoleWithPermissions(role, permissionIds);

            if (newRole != null) {
                resp.setContentType("application/json");
                resp.setCharacterEncoding("UTF-8");
                resp.setStatus(HttpServletResponse.SC_OK);

                // Trả về JSON chứa roleId và roleName
                String jsonResponse = gson.toJson(new HashMap<String, Object>() {{
                    put("roleId", newRole.getId());
                    put("roleName", newRole.getName());
                    put("message", "Thêm role thành công");
                }});

                resp.getWriter().write(jsonResponse);
            } else {
                resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                resp.getWriter().write("{\"message\": \"Thêm role thất bại\"}");
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

}
