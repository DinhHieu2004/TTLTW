package com.example.web.controller.previewController;

import com.example.web.service.PrivewService;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.io.PrintWriter;

@WebServlet("/reviews/update")
public class Update extends HttpServlet {
    private final PrivewService privewService = new PrivewService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        String rid = request.getParameter("rid");
        String content = request.getParameter("content");
        String rating = request.getParameter("rating");

        PrintWriter out = response.getWriter();

        if (rid == null || rid.isEmpty() || content == null || content.isEmpty() || rating == null || rating.isEmpty()) {
            out.print("{\"status\": \"error\", \"message\": \"Thiếu dữ liệu cập nhật\"}");
            return;
        }

        try {
            int reviewId = Integer.parseInt(rid);
            int reviewRating = Integer.parseInt(rating);

            boolean isUpdated = privewService.updateReview(reviewId, reviewRating, content);

            if (isUpdated) {
                out.print("{\"status\": \"success\"}");
            } else {
                out.print("{\"status\": \"error\", \"message\": \"Cập nhật đánh giá thất bại\"}");
            }
        } catch (Exception e) {
            out.print("{\"status\": \"error\", \"message\": \"" + e.getMessage() + "\"}");
        }
    }
}
