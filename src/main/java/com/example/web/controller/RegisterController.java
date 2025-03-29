package com.example.web.controller;

import com.example.web.dao.UserDao;
import com.example.web.service.AuthService;
import com.example.web.service.UserSerive;
import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

@WebServlet(name = "RegisterController", value = "/register")
public class RegisterController extends HttpServlet {
    AuthService auth = new AuthService();
    UserSerive userSerive = new UserSerive();
    Gson gson = new Gson();
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Lấy thông tin từ form đăng ký
        String username = getTrimmedParameter(request, "username");
        String email = getTrimmedParameter(request, "email");
        String password = getTrimmedParameter(request, "password");
        String fullName = getTrimmedParameter(request, "fullName");
        String phone = getTrimmedParameter(request, "phone");

        Map<String, String> responseMap = new HashMap<>();

        try {
            if (fullName.isEmpty()) {
                responseMap.put("errorName", "Họ và tên không được để trống!");
            }

            if (username.isEmpty()) {
                responseMap.put("errorUser", "Tên đăng nhập không được để trống!");
            } else if (userSerive.findByUsername(username) != null) {
                responseMap.put("errorUser", "Tên đăng nhập đã tồn tại!");
            }

            // Kiểm tra Email
            if (email.isEmpty()) {
                responseMap.put("errorEmail", "Email không được để trống!");
            } else if (!email.matches("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$")) {
                responseMap.put("errorEmail", "Email không hợp lệ!");
            }
            else if (userSerive.findByEmail(email) != null) {
                responseMap.put("errorEmail", "Email đã tồn tại!");
            }

            // Kiểm tra Password
            if (password.isEmpty()) {
                responseMap.put("errorPassword", "Mật khẩu không được để trống!");
            }
            else if (!password.matches("^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[@$!%*?&])[A-Za-z\\d@$!%*?&]{8,}$")) {
                responseMap.put("errorPassword", "Mật khẩu phải có ít nhất 8 ký tự, gồm chữ hoa, chữ thường, số và ký tự đặc biệt!");
            }

            // Kiểm tra Số điện thoại
            if ( phone != null && !phone.isEmpty() && !phone.matches("\\d{10}")) {
                responseMap.put("errorPhone", "Số điện thoại không hợp lệ!");
            }

            // Nếu có lỗi thì gửi JSON về frontend
            if (!responseMap.isEmpty()) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                sendJsonResponse(response, responseMap);
                System.out.println("dddd");
                return;
            }

            // Đăng ký người dùng mới
            boolean isRegistered = auth.registerUser(fullName, username, password, email, phone, "user");

            if (isRegistered) {
                responseMap.put("success", "Đăng ký thành công!");
                System.out.println("bbb");
            } else {
                // Đăng ký thất bại, thông báo lỗi
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
    private String getTrimmedParameter(HttpServletRequest request, String paramName) {
        String value = request.getParameter(paramName);
        return (value != null) ? value.trim() : null;
    }
    private void sendJsonResponse(HttpServletResponse response, Map<String, String> responseMap) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        try (PrintWriter out = response.getWriter()) {
            out.write(gson.toJson(responseMap));
            out.flush();
        }
    }
}
