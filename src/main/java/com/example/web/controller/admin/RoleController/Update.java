package com.example.web.controller.admin.RoleController;

import com.example.web.controller.util.CheckPermission;
import com.example.web.dao.model.User;
import com.example.web.service.RoleService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.HashSet;
import java.util.Set;

@WebServlet("/admin/roles/update")
public class Update extends HttpServlet {
    private RoleService roleService = new RoleService();

    private final String permission ="UPDATE_ROLES";


    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("user");

        boolean hasPermission = CheckPermission.checkPermission(user, permission, "ADMIN");
        if (!hasPermission) {
            resp.setStatus(HttpServletResponse.SC_FORBIDDEN);
            resp.setContentType("application/json");
            resp.setCharacterEncoding("UTF-8");
            resp.getWriter().write("{\"message\": \"Bạn không có quyền!\"}");
            return;
        }
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");

        try {
            // Lấy thông tin từ request
            String roleIdStr = req.getParameter("roleId");
            String roleName = req.getParameter("roleName");
            String[] permissionIdsArray = req.getParameterValues("permissionIds");



            // Kiểm tra và chuyển đổi roleId
            int roleId;
            if (roleIdStr != null && !roleIdStr.isEmpty()) {
                try {
                    roleId = Integer.parseInt(roleIdStr);
                } catch (NumberFormatException e) {
                    resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid roleId");
                    return;
                }
            } else {
                resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "roleId is required");
                return;
            }

            // Kiểm tra roleName
            if (roleName == null || roleName.trim().isEmpty()) {
                resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "roleName is required");
                return;
            }

            // Xử lý permissionIds
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

            // Gọi service để cập nhật role
            boolean updated = roleService.updateRole(roleId, roleName, permissionIds);

            // Phản hồi kết quả
            if (updated) {
                resp.setStatus(HttpServletResponse.SC_OK);
                resp.getWriter().write("{\"message\": \"Cập nhật quyền thành công\"}");
            } else {
                resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                resp.getWriter().write("{\"message\": \"Cập nhật quyền thất bại\"}");
            }

        } catch (Exception e) {
            e.printStackTrace();
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            resp.getWriter().write("{\"message\": \"Lỗi khi cập nhật quyền: " + e.getMessage() + "\"}");
        }
    }
}