package com.example.web.controller;

import com.example.web.dao.PaintingDao;
import com.example.web.dao.model.*;
import com.example.web.service.*;
import jakarta.servlet.ServletContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

import java.net.http.HttpRequest;
import java.sql.SQLException;
import java.util.List;

@WebServlet(name = "InitServlet", loadOnStartup = 1, value = "/init")

public class InitServlet extends HttpServlet {
    private SizeService sizeService = new SizeService();
    private ArtistService artistService = new ArtistService();
    private ThemeService themeService = new ThemeService();
    private PaintingDao paintingDao = new PaintingDao();
    private PaintingService paintingService = new PaintingService();
    private final DiscountService discountService = new DiscountService();

    private static User currentUser ;


    @Override
    public void init() throws ServletException {
        try {
            List<Artist> artists = artistService.getAllArtists();
            List<PaintingSize> sizes = sizeService.getAllSize();
            List<Theme> themes = themeService.getAllTheme();
            List<Painting> featuredArtworks = paintingDao.getFeaturedArtworks();
            List<Painting> flashSaleArtworks = paintingDao.getFlashSaleArtworks();
            List<Painting> newP = paintingService.getNewestPaintings();

            System.out.println(sizes);
            ServletContext context = getServletContext();
            context.setAttribute("artists", artists);
            context.setAttribute("sizes", sizes);
            context.setAttribute("themes", themes);
            List<Painting> bestP = paintingService.getRandomTopRatedPaintings();
            context.setAttribute("bp", bestP);
            context.setAttribute("featuredArtworks", featuredArtworks);
            context.setAttribute("flashSaleArtworks", flashSaleArtworks);
            context.setAttribute("newP", newP);

            String flashSaleEndDateTime = "";
            List<Discount> list = discountService.getAllDiscount();
            for (Discount discount : list) {
                if("Flash Sale".equalsIgnoreCase(discount.getDiscountName())) {
                    flashSaleEndDateTime = discount.getEndDate().atTime(23, 59, 59).toString();
                    break;
                }
            }
            context.setAttribute("flashSaleEndDateTime", flashSaleEndDateTime);


        } catch (SQLException e) {
            throw new ServletException("Failed to load artists", e);
        }
    }

}
