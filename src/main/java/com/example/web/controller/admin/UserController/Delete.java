package com.example.web.controller.admin.UserController;
import com.example.web.service.ArtistService;
import com.example.web.service.UserSerive;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/admin/users/delete")
public class Delete extends HttpServlet {
    private UserSerive userSerive = new UserSerive();
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        String id = request.getParameter("userId");
        try {
            boolean isDeleted = userSerive.deleteUser(Integer.parseInt(id));
            if (isDeleted) {
                request.setAttribute("message", "Xóa người dùng thành công!");
            } else {
                request.setAttribute("message", "Xóa người dùng thất bại!");
            }
        } catch (Exception e) {
            request.setAttribute("message", "Lỗi: " + e.getMessage());
        }
        response.sendRedirect("../users");
    }


}
