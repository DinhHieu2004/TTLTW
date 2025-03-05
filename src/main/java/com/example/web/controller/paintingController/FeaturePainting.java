package com.example.web.controller.paintingController;


import com.example.web.dao.PaintingDao;
import com.example.web.dao.model.Painting;
import com.example.web.dao.model.Theme;
import com.example.web.service.PaintingService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

//@WebServlet("/")
public class FeaturePainting extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        PaintingDao paintingDAO = new PaintingDao();
        PaintingService paintingService = new PaintingService();

        List<Painting> featuredArtworks = paintingDAO.getFeaturedArtworks();
        try {
            List<Painting> bestP = paintingService.getRandomTopRatedPaintings();
            request.setAttribute("bp", bestP);
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }


        List<Theme> themes = null;
        try {
            themes = paintingDAO.getTheme();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }

        request.setAttribute("featuredArtworks", featuredArtworks);
        request.setAttribute("themes", themes);



        // Chuyển hướng tới trang index để hiển thị danh sách
        request.getRequestDispatcher("index.jsp").forward(request, response);

    }

}

