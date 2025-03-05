package com.example.web.controller.admin.UserController;

import com.example.web.dao.model.User;
import com.example.web.service.UserSerive;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;


@WebServlet("/admin/users/update")
public class Update extends HttpServlet {
    private UserSerive userSerive = new UserSerive();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        int id =Integer.parseInt(req.getParameter("id"));
        String username = req.getParameter("username");
        String password = req.getParameter("password");
        String email = req.getParameter("email");
        String phone = req.getParameter("phone");
        String address = req.getParameter("address");
        String fullName = req.getParameter("fullName");
        String role = req.getParameter("role");

        User.Role roleEnum = User.Role.valueOf(role);

        User user =  new User(id,fullName, username,address, email, phone, roleEnum, password);
        System.out.println(user);

        try {
            boolean isUpdated = userSerive.updateUser(user);
            if (isUpdated) {
                resp.sendRedirect("../users");
            } else {
                resp.getWriter().write("{\"success\": false, \"message\": \"Cập nhật thất bại.\"}");
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }
}
