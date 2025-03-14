package com.example.web.controller.paintingController;

import com.example.web.dao.model.Artist;
import com.example.web.dao.model.Painting;
import com.example.web.dao.model.PaintingSize;
import com.example.web.dao.model.Theme;
import com.example.web.service.ArtistService;
import com.example.web.service.PaintingService;
import com.example.web.service.SizeService;
import com.example.web.service.ThemeService;
import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet(name = "Artwork", value = {"/artwork", "/artwork/suggestions"})
public class GetList extends HttpServlet {
    private PaintingService ps = new PaintingService();
    private ArtistService as = new ArtistService();
    private ThemeService ts = new ThemeService();
    private SizeService ss = new SizeService();
    private Gson gson = new Gson();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath();

        if ("/artwork/suggestions".equals(path)) {
            try {
                handleSearchSuggestions(req, resp);
            } catch (SQLException e) {
                resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error");
            }
            return;
        }

        int currentPage = parseInt(req.getParameter("page"), 1);
        int recordsPerPage = 12;

        try {
            String keyWord = req.getParameter("keyword");
            Double minPrice = parseDouble(req.getParameter("minPrice"));
            Double maxPrice = parseDouble(req.getParameter("maxPrice"));
            String[] themeArr = req.getParameterValues("theme");
            String[] artistArr = req.getParameterValues("artist");
            String startDate = req.getParameter("startDate");
            String endDate = req.getParameter("endDate");
            boolean sortNew = "snew".equals(req.getParameter("snew"));
            boolean isSortByRating = "rating".equals(req.getParameter("sort"));

            List<Painting> data = ps.getPaintingList(keyWord, minPrice, maxPrice, themeArr, artistArr,
                    startDate, endDate, isSortByRating, sortNew, currentPage, recordsPerPage);
            int totalRecords = ps.countPaintings(keyWord, minPrice, maxPrice, themeArr, artistArr, startDate, endDate);
            int totalPages = (int) Math.ceil((double) totalRecords / recordsPerPage);

            if ("XMLHttpRequest".equals(req.getHeader("X-Requested-With"))) {
                sendAjaxResponse(resp, data, currentPage, totalPages, totalRecords);
                return;
            }

            req.setAttribute("data", data);
            req.setAttribute("artists", as.getAllArtists());
            req.setAttribute("themes", ts.getAllTheme());
            req.setAttribute("paintingSizes", ss.getAllSize());
            req.setAttribute("currentPage", currentPage);
            req.setAttribute("totalPages", totalPages);
            req.getRequestDispatcher("user/artWork.jsp").forward(req, resp);

        } catch (SQLException e) {
            resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi lấy dữ liệu");
        }
    }

    private void handleSearchSuggestions(HttpServletRequest req, HttpServletResponse resp) throws IOException, SQLException {
        String keyword = req.getParameter("keyword");
        if (keyword == null || keyword.trim().isEmpty() || keyword.length() <= 2) {
            resp.setContentType("application/json");
            resp.setCharacterEncoding("UTF-8");
            PrintWriter out = resp.getWriter();
            out.print(gson.toJson(new String[]{}));
            out.flush();
            return;
        }

        List<String> suggestions = ps.getPaintingSg(keyword, 5); // Giả sử method này là getPaintingSuggestions
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");
        PrintWriter out = resp.getWriter();
        out.print(gson.toJson(suggestions));
        out.flush();
    }

    private void sendAjaxResponse(HttpServletResponse resp, List<Painting> data, int currentPage,
                                  int totalPages, int totalRecords) throws IOException {
        Map<String, Object> response = new HashMap<>();
        response.put("data", data);
        response.put("currentPage", currentPage);
        response.put("totalPages", totalPages);
        response.put("totalRecords", totalRecords);

        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");
        PrintWriter out = resp.getWriter();
        out.print(gson.toJson(response));
        out.flush();
    }

    private int parseInt(String param, int defaultValue) {
        if (param != null && !param.isEmpty()) {
            try {
                return Integer.parseInt(param);
            } catch (NumberFormatException e) {
                return defaultValue;
            }
        }
        return defaultValue;
    }

    private Double parseDouble(String param) {
        if (param != null && !param.isEmpty()) {
            try {
                return Double.parseDouble(param);
            } catch (NumberFormatException e) {
                return null;
            }
        }
        return null;
    }
}