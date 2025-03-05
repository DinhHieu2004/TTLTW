package com.example.web.controller.paintingController;

import com.example.web.dao.model.Artist;
import com.example.web.dao.model.Painting;
import com.example.web.dao.model.PaintingSize;
import com.example.web.dao.model.Theme;
import com.example.web.service.ArtistService;
import com.example.web.service.PaintingService;
import com.example.web.service.SizeService;
import com.example.web.service.ThemeService;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet(name ="Artwork", value = "/artwork")
public class GetList extends HttpServlet {
    PaintingService ps = new PaintingService();
    ArtistService as = new ArtistService();
    ThemeService ts = new ThemeService();
    SizeService ss = new SizeService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        int currentPage = 1;
        int recordsPerPage = 12;

        String pageParam = req.getParameter("page");
        if (pageParam != null && !pageParam.isEmpty()) {
            try {
                currentPage = Integer.parseInt(pageParam);
            } catch (NumberFormatException e) {
                RequestDispatcher dispatcher = req.getRequestDispatcher("/404.jsp");
                dispatcher.forward(req, resp);
                resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid page number");
                return;
            }
        }
        List<Painting>  data = null;
        List<Artist>  artists = null;
        List<Theme> themes = null;
        List<PaintingSize> paintingSizes = null;
        try {
            String sort = req.getParameter("sort");
            String newP = req.getParameter("snew");
            boolean sortNew = (newP != null && newP.equals("snew"));
            boolean isSortByRating = (sort != null && sort.equals("rating"));
            String keyWord = req.getParameter("keyword");
            String minPriceParam = req.getParameter("minPrice");
            String maxPriceParam = req.getParameter("maxPrice");
            String[] themeArr = req.getParameterValues("theme");
            String[] artistArr = req.getParameterValues("artist");
            String startDate = req.getParameter("startDate");
            String endDate = req.getParameter("endDate");

            Double minPrice = null;
            Double maxPrice = null;

            try {
                if (minPriceParam != null && !minPriceParam.isEmpty()) {
                    minPrice = Double.valueOf(minPriceParam);
                }
                if (maxPriceParam != null && !maxPriceParam.isEmpty()) {
                    maxPrice = Double.valueOf(maxPriceParam);
                }



            } catch (NumberFormatException e) {
                resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid price format");
                return;
            }
            data  = ps.getPaintingList(keyWord,minPrice, maxPrice, themeArr, artistArr,startDate, endDate,isSortByRating,sortNew, currentPage, recordsPerPage);
            int totalRecords = ps.countPaintings(keyWord,minPrice, maxPrice, themeArr, artistArr,startDate, endDate);
            int totalPages = (int) Math.ceil((double) totalRecords / recordsPerPage);

            artists = as.getAllArtists();
            themes = ts.getAllTheme();
            paintingSizes = ss.getAllSize();


            req.setAttribute("data", data);
            req.setAttribute("artists", artists);
            req.setAttribute("themes", themes);
            req.setAttribute("paintingSizes", paintingSizes);

            req.setAttribute("currentPage", currentPage);
            req.setAttribute("recordsPerPage", recordsPerPage);
            req.setAttribute("totalPages", totalPages);

        } catch (SQLException e) {
            RequestDispatcher dispatcher = req.getRequestDispatcher("/404.jsp");
            dispatcher.forward(req, resp);
            throw new RuntimeException(e);
        }

        req.getRequestDispatcher("user/artWork.jsp").forward(req  ,resp);

    }



}
