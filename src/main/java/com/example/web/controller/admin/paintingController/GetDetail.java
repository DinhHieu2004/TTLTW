package com.example.web.controller.admin.paintingController;

import com.example.web.controller.util.GsonProvider;
import com.example.web.dao.model.Artist;
import com.example.web.dao.model.Painting;
import com.example.web.service.ArtistService;
import com.example.web.service.PaintingService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/admin/products/detail")
public class GetDetail extends HttpServlet {
    private PaintingService paintingService = new PaintingService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        int pid = Integer.parseInt(req.getParameter("pid"));

        try {
            Painting painting = paintingService.getPaintingDetail(pid);
            resp.setContentType("application/json");
            resp.setCharacterEncoding("UTF-8");
            resp.getWriter().write(GsonProvider.getGson().toJson(painting));
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }
}
