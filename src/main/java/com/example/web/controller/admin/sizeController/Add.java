package com.example.web.controller.admin.sizeController;


import com.example.web.service.SizeService;
import com.example.web.service.ThemeService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/admin/sizes/add")
public class Add extends HttpServlet {
    private SizeService sizeService = new SizeService();
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String description = req.getParameter("description");

        try {
            boolean isAdd = sizeService.addSize(description);
            if (isAdd) {
                resp.sendRedirect("../products");
               // req.setAttribute("message", "thêm thành công!");
              //  req.getRequestDispatcher("../products.jsp").forward(req, resp);

            } else {
                resp.getWriter().write("{\"success\": false, \"message\": \"Them thất bại.\"}");
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }


    }
}
