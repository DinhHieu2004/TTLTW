package com.example.web.controller.previewController;

import com.example.web.service.PrivewService;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.PrintWriter;

@WebServlet("/admin/review_admin/update")
public class Update extends HttpServlet {
    private final PrivewService privewService = new PrivewService();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("application/json");
        PrintWriter out = resp.getWriter();

        try {
            // Đọc toàn bộ request body
            StringBuilder sb = new StringBuilder();
            String line;
            BufferedReader reader = req.getReader();
            while ((line = reader.readLine()) != null) {
                sb.append(line);
            }
            String jsonBody = sb.toString();

            // Parse JSON
            JsonObject jsonObject = JsonParser.parseString(jsonBody).getAsJsonObject();
            int id = jsonObject.get("id").getAsInt();
            int rating = jsonObject.get("rating").getAsInt();
            String comment = jsonObject.get("comment").getAsString();

            // Xử lý logic
            boolean success = privewService.updateReview(id, rating, comment);

            // Trả về response
            if (success) {
                out.print("{\"success\": true, \"message\": \"Cập nhật thành công!\"}");
            } else {
                out.print("{\"success\": false, \"error\": \"Không thể cập nhật đánh giá!\"}");
            }
        } catch (Exception e) {
            out.print("{\"success\": false, \"error\": \"Lỗi hệ thống: " + e.getMessage() + "\"}");
        }
    }
}
