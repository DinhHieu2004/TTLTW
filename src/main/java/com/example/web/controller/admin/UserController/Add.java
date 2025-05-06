package com.example.web.controller.admin.UserController;

import com.example.web.controller.util.CheckPermission;
import com.example.web.dao.model.User;
import com.example.web.service.UserService;
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
import java.util.Map;

@WebServlet("/admin/users/add")
public class Add extends HttpServlet {
    private Gson gson = new Gson();
    private UserService userService = new UserService();
    private final String permission = "ADD_USERS";


    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User userC = (User) session.getAttribute("user");
        Map<String, Object> responseMap = new HashMap<>();

        boolean hasPermission = CheckPermission.checkPermission(userC, permission, "ADMIN");
        if (!hasPermission) {
            responseMap.put("errorPermission", "bạn khong có quyền!");

            //   response.sendRedirect(request.getContextPath() + "/NoPermission.jsp");
            return;
        }
        String fullName = request.getParameter("fullName");
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String address = request.getParameter("address");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");



        try {
            if (fullName.isEmpty()) {
                responseMap.put("errorName", "Họ và tên không được để trống!");
            }
            if (username.isEmpty()) {
                responseMap.put("errorUser", "Tên đăng nhập không được để trống!");
            } else if (userService.findByUsername(username) != null) {
                responseMap.put("errorUser", "Tên đăng nhập đã tồn tại!");
            }

            if (email.isEmpty()) {
                responseMap.put("errorEmail", "Email không được để trống!");
            } else if (!email.matches("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$")) {
                responseMap.put("errorEmail", "Email không hợp lệ!");
            } else if (userService.findByEmail(email) != null) {
                responseMap.put("errorEmail", "Email đã tồn tại!");
            }

            if (password.isEmpty()) {
                responseMap.put("errorPassword", "Mật khẩu không được để trống!");
            } else if (!password.matches("^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[@$!%*?&])[A-Za-z\\d@$!%*?&]{8,}$")) {
                responseMap.put("errorPassword", "Mật khẩu phải có ít nhất 8 ký tự, gồm chữ hoa, chữ thường, số và ký tự đặc biệt!");
            }

            if (phone != null && !phone.isEmpty() && !phone.matches("\\d{10}")) {
                responseMap.put("errorPhone", "Số điện thoại không hợp lệ!");
            }

            if (!responseMap.isEmpty()) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                sendJsonResponse(response, responseMap);
                System.out.println("dddd");
                return;
            }
            boolean isRegistered = userService.addUser(fullName, username, password, email, phone, "user", address);

            if (isRegistered) {
                User user = userService.findByUsername(username);
                responseMap.put("success", "Đăng ký thành công!");
                responseMap.put("user", user);
                System.out.println("bbb");
            } else {
                responseMap.put("errorMessage", "Đăng ký không thành công. Vui lòng thử lại.");
                System.out.println("phone");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            responseMap.put("errorDatabase", "Lỗi hệ thống, vui lòng thử lại sau.");

        }
        sendJsonResponse(response, responseMap);
    }

    private void sendJsonResponse(HttpServletResponse response, Map<String, Object> responseMap) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        try (PrintWriter out = response.getWriter()) {
            out.write(gson.toJson(responseMap));
            out.flush();
        }
    }

}