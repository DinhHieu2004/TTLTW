package com.example.web.controller.admin.previewController;

import com.example.web.dao.model.ProductReview;
import com.example.web.service.PrivewService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/admin/reviews")
public class GetList extends HttpServlet {
    private PrivewService privewService = new PrivewService();
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            List<ProductReview> p = privewService.getAll();
            req.setAttribute("p", p);
            req.getRequestDispatcher("previews.jsp").forward(req, resp);
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }
}
