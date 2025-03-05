package com.example.web.controller;

import com.example.web.dao.UserDao;
import com.example.web.dao.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;

@WebServlet(name = "updateInfo", value = "/update-personal-info")
public class UpdateInfoController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false); // Lấy session nếu có, không tạo mới

        // Lấy thông tin từ session và form
        User currentUser = (User) session.getAttribute("user");
        String fullName = request.getParameter("fullName");
        String phone = request.getParameter("phone");
        String email = request.getParameter("email");
        String address = request.getParameter("address");

        UserDao userDao = new UserDao();

        try {
            // Kiểm tra tính hợp lệ của dữ liệu (có thể thêm logic kiểm tra chi tiết hơn)
            if (fullName == null || fullName.trim().isEmpty() ||
                    phone == null || phone.trim().isEmpty() ||
                    email == null || email.trim().isEmpty()) {
                request.setAttribute("errorMessage", "Vui lòng điền đầy đủ thông tin!");
                request.getRequestDispatcher("/user/personal.jsp").forward(request, response);
                return;
            }

            // Cập nhật thông tin người dùng
            currentUser.setFullName(fullName);
            currentUser.setPhone(phone);
            currentUser.setEmail(email);
            currentUser.setAddress(address);

            boolean isUpdated = userDao.updateUserInfo(currentUser);
            if (isUpdated) {
                request.setAttribute("successMessage", "Cập nhật thông tin thành công!");
                session.setAttribute("user", currentUser); // Cập nhật lại thông tin trong session
            } else {
                request.setAttribute("errorMessage", "Đã xảy ra lỗi, vui lòng thử lại!");
            }

            request.getRequestDispatcher("/user/personal.jsp").forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Lỗi hệ thống, vui lòng thử lại sau!");
            request.getRequestDispatcher("/user/personal.jsp").forward(request, response);
        }
    }
}

