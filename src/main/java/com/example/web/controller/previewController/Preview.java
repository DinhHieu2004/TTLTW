package com.example.web.controller.previewController;

import com.example.web.dao.model.Painting;
import com.example.web.dao.model.ProductReview;
import com.example.web.dao.model.User;
import com.example.web.service.PaintingService;
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
import java.util.List;

@WebServlet(name= "review", value = "/review")
public class Preview extends HttpServlet {
    private PaintingService paintingService = new PaintingService();
    private PrivewService privewService = new PrivewService();
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        int id = Integer.parseInt(req.getParameter("itemId"));
        try {
            List<ProductReview> reviews = privewService.getReviewByItemId(id);
            Painting painting = paintingService.getPaintingByItemId(id);
            System.out.println(painting);
            req.setAttribute("p", painting);
            req.setAttribute("reviews", reviews);

        } catch (SQLException e) {
            throw new RuntimeException(e);
        }

        req.getRequestDispatcher("user/preview.jsp").forward(req, resp);

    }
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("application/json");
        PrintWriter out = resp.getWriter();

        try {
            HttpSession session = req.getSession();
            User user = (User) session.getAttribute("user");

            if (user == null) {
                resp.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                out.print("{\"error\": \"User not authenticated\"}");
                return;
            }

            String paintingIdParam = req.getParameter("paintingId");
            String itemIdParam = req.getParameter("itemId");
            String ratingParam = req.getParameter("rating");
            String comment = req.getParameter("comment");

            // Kiểm tra null và parse các tham số
            if (paintingIdParam == null || itemIdParam == null || ratingParam == null) {
                resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.print("{\"error\": \"Missing required parameters (paintingId, itemId, rating)\"}");
                return;
            }

            int paintingId = Integer.parseInt(paintingIdParam);
            int orderItemId = Integer.parseInt(itemIdParam);
            int rating = Integer.parseInt(ratingParam);

            if (comment == null) {
                comment = "";
            }

            System.out.println("uid: " + user.getId());
            System.out.println("pid: " + paintingId);
            System.out.println("itemId: " + orderItemId);
            System.out.println("rating: " + rating);
            System.out.println("comment: " + comment);

             ProductReview review = new ProductReview(user.getId(), paintingId, orderItemId, rating, comment);
             privewService.submitReview(review);

            resp.setStatus(HttpServletResponse.SC_OK);
            out.print("{\"message\": \"Đánh giá của bạn đã được gửi thành công!\"}");
        } catch (NumberFormatException e) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print("{\"error\": \"Invalid number format for parameters\"}");
        } catch (Exception e) {
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"error\": \"An error occurred: " + e.getMessage() + "\"}");
        }
    }

}
