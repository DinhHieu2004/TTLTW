package com.example.web.controller.previewController;

import com.example.web.dao.model.Painting;
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

@WebServlet(name= "preview", value = "/review/add")

public class add extends HttpServlet {
    private PaintingService paintingService = new PaintingService();
    private PrivewService privewService = new PrivewService();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("application/json");
        PrintWriter out = resp.getWriter();

        try {
            HttpSession session = req.getSession();
            User user = (User) session.getAttribute("user");
            int userId = user.getId();
            int paintingId = Integer.parseInt(req.getParameter("paintingId"));
            int orderItemId = Integer.parseInt(req.getParameter("itemId"));
            int rating = Integer.parseInt(req.getParameter("rating"));
            String comment = req.getParameter("comment");


            System.out.println("uid: "+userId);
            System.out.println("pid:"+paintingId);
            System.out.println(orderItemId);
            System.out.println(rating);
            System.out.println(comment);

            //ProductReview review = new ProductReview(userId, paintingId, orderItemId, rating, comment);
            //privewService.submitReview(review);

            resp.setStatus(HttpServletResponse.SC_OK);
            out.print("{\"message\": \"Đánh giá của bạn đã được gửi thành công!\"}");
        } catch (Exception e) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print("{\"error\": \"" + e.getMessage() + "\"}");
        }
    }
}
