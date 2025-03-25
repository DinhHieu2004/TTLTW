package com.example.web.controller.admin.previewController;

import com.example.web.dao.model.ProductReview;
import com.example.web.service.PrivewService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/admin/reviews/delete")
public class delete extends HttpServlet {
    private final PrivewService privewService = new PrivewService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");

        if (userId == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write("{\"status\": \"error\", \"message\": \"Bạn cần đăng nhập để xóa đánh giá!\"}");
            return;
        }
        String rid = request.getParameter("rid");

        try {
            int reviewId = Integer.parseInt(rid);

            ProductReview review = privewService.getReviewById(reviewId);
            if (review == null || review.getUserId() != userId) {
                response.setStatus(HttpServletResponse.SC_FORBIDDEN);
                response.getWriter().write("{\"status\": \"error\", \"message\": \"Bạn không có quyền chỉnh sửa đánh giá này!\"}");
                return;
            }
            boolean isDeleted = privewService.deleteReviewById(reviewId);

            if (isDeleted) {
                response.setStatus(HttpServletResponse.SC_OK);
                response.getWriter().write("{\"message\": \"Xóa đánh giá thành công!\"}");
            } else {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"message\": \"Xóa đánh giá thất bại!\"}");
            }
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"message\": \"ID đánh giá không hợp lệ!\"}");
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"message\": \"Lỗi: " + e.getMessage() + "\"}");
        }
    }
}
