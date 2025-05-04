package com.example.web.controller.admin.UserController;

import com.example.web.controller.util.CheckPermission;
import com.example.web.dao.model.User;
import com.example.web.service.UserSerive;
import com.example.web.utils.SessionManager;
import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;


@WebServlet("/admin/users/update")
public class Update extends HttpServlet {
    private UserSerive userSerive = new UserSerive();

    private final String permission ="UPDATE_USERS";


    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        User userC = (User) session.getAttribute("user");

        Map<String, Object> responseMap = new HashMap<>();
        Map<String, String> errors = new HashMap<>();

        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");
        Gson gson = new Gson();


        boolean hasPermission = CheckPermission.checkPermission(userC, permission, "ADMIN");
        if (!hasPermission) {

            resp.setStatus(HttpServletResponse.SC_FORBIDDEN); // 403
            responseMap.put("message", "bạn không có quyền!");

            try (PrintWriter out = resp.getWriter()) {
                    out.write(gson.toJson(responseMap));
                    out.flush();
                }
                return;

        }


            try {
                int id = Integer.parseInt(req.getParameter("id"));
                String username = req.getParameter("username");
                String email = req.getParameter("email");
                String phone = req.getParameter("phone");
                String address = req.getParameter("address");
                String fullName = req.getParameter("fullName");

                String[] roleIdArray = req.getParameterValues("roleIds");
                System.out.println("roleid: "+ roleIdArray);

                Set<Integer> roleIds = new HashSet<>();
                if (roleIdArray != null && roleIdArray.length > 0) {
                    for (String roleId : roleIdArray) {
                        try {
                            roleIds.add(Integer.parseInt(roleId));
                        } catch (NumberFormatException e) {
                            System.err.println("Invalid roleId: " + roleId);
                        }
                    }
                } else {
                    resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "At least one permission must be selected");
                    return;
                }



                if (fullName == null || fullName.isEmpty()) {
                    errors.put("changeNameError", "Họ và tên không được để trống!");
                }
                if (username == null || username.isEmpty()) {
                    errors.put("changUsernameError", "Tên đăng nhập không được để trống!");
                } else if (userSerive.findByUsername(username) != null && !username.equals(getCurrentUsername(id))) {
                    errors.put("changUsernameError", "Tên đăng nhập đã tồn tại!");
                }

                if (email == null || email.isEmpty()) {
                    errors.put("changeEmailError", "Email không được để trống!");
                } else if (!email.matches("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$")) {
                    errors.put("changeEmailError", "Email không hợp lệ!");
                } else if (userSerive.findByEmail(email) != null && !email.equals(getCurrentEmail(id))) {
                    errors.put("changeEmailError", "Email đã tồn tại!");
                }

                if (phone != null && !phone.isEmpty() && !phone.matches("\\d{10}")) {
                    errors.put("changePhoneError", "Số điện thoại không hợp lệ!");
                }

                if (!errors.isEmpty()) {
                    responseMap.put("status", "fail");
                    responseMap.put("errors", errors);
                    resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    try (PrintWriter out = resp.getWriter()) {
                        out.write(gson.toJson(responseMap));
                        out.flush();
                    }
                    return;
                }


                User user = new User(id, fullName, username, address, email, phone, null);

                boolean isUpdated = userSerive.updateUser(user, roleIds);

                if (isUpdated) {
                    User up = userSerive.getUser(user.getId());

                    //khi thay đổi bất kì thong tin nào thì cũng nên buộc đăng xuất
                    HttpSession userSession = SessionManager.userSessions.get(up.getId()+"");
                    if (userSession != null) {
                        userSession.invalidate();
                        SessionManager.userSessions.remove(up.getEmail());
                    }

                    responseMap.put("message", "Cập nhật thành công!");
                    responseMap.put("user", up);
                    resp.setStatus(HttpServletResponse.SC_OK);


                    responseMap.put("message", "Cập nhật thành công!");
                    responseMap.put("user", up);
                    resp.setStatus(HttpServletResponse.SC_OK);
                } else {
                    responseMap.put("messageE", "Cập nhật thất bại!");
                    resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                }
            } catch (Exception e) {
                responseMap.put("status", "error");
                responseMap.put("message", "Lỗi hệ thống: " + e.getMessage());
                resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            }

            try (PrintWriter out = resp.getWriter()) {
                out.write(gson.toJson(responseMap));
                out.flush();
            }
        }

        private String getCurrentUsername(int id) throws SQLException {
            User currentUser = userSerive.findById(id);
            return currentUser != null ? currentUser.getUsername() : "";
        }

        private String getCurrentEmail(int id) throws SQLException {
            User currentUser = userSerive.findById(id);
            return currentUser != null ? currentUser.getEmail() : "";
        }

}
