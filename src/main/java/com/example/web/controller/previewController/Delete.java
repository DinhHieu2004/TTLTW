package com.example.web.controller.previewController;


import com.example.web.dao.model.Level;
import com.example.web.dao.model.User;
import com.example.web.service.LogService;
import com.example.web.service.PrivewService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;

@WebServlet("/review/delete")
public class Delete extends HttpServlet {
    private final PrivewService privewService = new PrivewService();
    private final LogService logService = new LogService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        String rid = request.getParameter("rid");
        PrintWriter out = response.getWriter();

        try {
            int reviewId = Integer.parseInt(rid);
            boolean isDeleted = privewService.deleteReviewById(reviewId);

            if (isDeleted) {
                User user = (User) request.getSession().getAttribute("user");

                if (user != null) {
                    logService.addLog(String.valueOf(Level.DANGER), request, null, null);
                } else {
                    logService.addLog(String.valueOf(Level.DANGER), request,  null, null);
                }
                response.setStatus(HttpServletResponse.SC_OK);
                out.print("{\"status\": \"success\", \"message\": \"Xóa đánh giá thành công\"}");
            } else {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.print("{\"status\": \"error\", \"message\": \"Xóa đánh giá thất bại\"}");
            }
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print("{\"status\": \"error\", \"message\": \"ID đánh giá không hợp lệ\"}");
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"status\": \"error\", \"message\": \"" + e.getMessage() + "\"}");
        } finally {
            out.flush();
        }
    }
}



