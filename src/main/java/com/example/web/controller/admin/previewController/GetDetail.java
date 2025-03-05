package com.example.web.controller.admin.previewController;
import com.example.web.controller.util.GsonProvider;
import com.example.web.dao.model.ProductReview;
import com.example.web.service.PrivewService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/admin/reviews/detail")
public class GetDetail extends HttpServlet {
    private PrivewService privewService = new PrivewService();
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        int id = Integer.parseInt( req.getParameter("rid"));

        try {
            ProductReview v =  privewService.getReviewById(id);
            resp.setContentType("application/json");
            resp.setCharacterEncoding("UTF-8");
            resp.getWriter().write(GsonProvider.getGson().toJson(v));
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }
}
