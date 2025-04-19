package com.example.web.controller.admin.previewController;
import com.example.web.controller.util.CheckPermission;
import com.example.web.dao.model.Level;
import com.example.web.dao.model.ProductReview;
import com.example.web.dao.model.User;
import com.example.web.service.LogService;
import com.example.web.service.PrivewService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;

@WebServlet("/admin/reviews/update")
public class Update extends HttpServlet {
    private final PrivewService privewService = new PrivewService();
    private final LogService logService = new LogService();
    private final String permission ="UPDATE_REVIEWS";


    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        boolean hasPermission = CheckPermission.checkPermission(user, permission, "ADMIN");
        if (!hasPermission) {
            response.sendRedirect(request.getContextPath() + "/NoPermission.jsp");
            return;
        }

        Integer userId = (Integer) session.getAttribute("userId");

        if (userId == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().print("{\"status\": \"error\", \"message\": \"Bạn cần đăng nhập để chỉnh sửa đánh giá!\"}");
            return;
        }

        int reviewId = Integer.parseInt(request.getParameter("reviewId"));
        int newRating = Integer.parseInt(request.getParameter("newRating"));
        String newComment = request.getParameter("newComment");

        boolean success = false;
        try {
            ProductReview review = privewService.getReviewById(reviewId);
            if (review == null || review.getUserId() != userId && userId != 4) {
                response.setStatus(HttpServletResponse.SC_FORBIDDEN);
                response.getWriter().print("{\"status\": \"error\", \"message\": \"Bạn không có quyền chỉnh sửa đánh giá này!\"}");
                return;
            }
            success = privewService.updateReview(reviewId,newRating ,newComment);
          //  User user = (User) request.getSession().getAttribute("user");

            if (user != null) {
                logService.addLog(String.valueOf(Level.WARNING), request, null, null);
            } else {
                logService.addLog(String.valueOf(Level.WARNING), request,  null, null);
            }
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
