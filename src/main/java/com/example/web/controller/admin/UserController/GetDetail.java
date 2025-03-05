package com.example.web.controller.admin.UserController;

import com.example.web.controller.util.GsonProvider;
import com.example.web.dao.model.User;
import com.example.web.service.UserSerive;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;


@WebServlet("/admin/users/detail")

public class GetDetail extends HttpServlet {
    private UserSerive userSerive = new UserSerive();

    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        int userId = Integer.parseInt(req.getParameter("userId"));
        try {
            System.out.println(userId);

            User user = userSerive.getUser(userId);
            System.out.println(user);

            resp.setContentType("application/json");
            resp.setCharacterEncoding("UTF-8");
            resp.getWriter().write(GsonProvider.getGson().toJson(user));
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }
}
