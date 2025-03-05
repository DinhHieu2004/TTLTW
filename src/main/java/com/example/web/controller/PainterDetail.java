package com.example.web.controller;

import com.example.web.dao.PaintingDao;
import com.example.web.dao.model.Artist;
import com.example.web.dao.model.Painting;
import com.example.web.service.ArtistService;
import com.example.web.service.PaintingService;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet(name ="PainterDetail", value ="/painter-detail")
public class PainterDetail extends HttpServlet {
    private ArtistService artistService = new ArtistService();
    private PaintingService paintingService = new PaintingService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        int id = Integer.parseInt(req.getParameter("id"));
        try {

            Artist data = artistService.getArtistById(id);
            List<Painting> listPainting = paintingService.getListPaintingByArtist(id);
            req.setAttribute("listP", listPainting);

            req.setAttribute("data", data);

            if(data == null ) {
                RequestDispatcher dispatcher = req.getRequestDispatcher("/404.jsp");
                dispatcher.forward(req, resp);
            }

        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        req.getRequestDispatcher("user/painter.jsp").forward(req, resp);
    }
}
