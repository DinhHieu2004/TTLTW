package com.example.web.controller.admin.previewController;

import com.example.web.service.PrivewService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;

@WebServlet("/admin/reviews/update")
public class Update extends HttpServlet {
    private final PrivewService privewService = new PrivewService();
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int reviewId = Integer.parseInt(request.getParameter("reviewId"));
        int newRating = Integer.parseInt(request.getParameter("newRating"));
        String newComment = request.getParameter("newComment");

        boolean success = false;
        try {
            success = privewService.updateReview(reviewId,newRating ,newComment);
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }

        response.setContentType("application/json");
        PrintWriter out = response.getWriter();

        if (success) {
            out.print("{\"status\": \"success\"}");
        } else {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"status\": \"error\", \"message\": \"Cập nhật thất bại\"}");
        }
        out.flush();
    }
}
