package com.example.web.controller;

import com.example.web.dao.DiscountDao;
import com.example.web.dao.model.*;
import com.example.web.service.*;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.List;

@WebServlet("/discount_content")
public class DiscountContent extends HttpServlet {
    PaintingService ps = new PaintingService();
    ArtistService as = new ArtistService();
    ThemeService ts = new ThemeService();
    SizeService ss = new SizeService();
    DiscountService ds = new DiscountService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        int currentPage = 1;
        int recordsPerPage = 8;

        // Lấy discountId từ request
        String discountIdParam = req.getParameter("id");
        if (discountIdParam == null || discountIdParam.isEmpty()) {
            resp.sendRedirect("/user/discount");
            return;
        }

        int discountId;
        try {
            discountId = Integer.parseInt(discountIdParam);
        } catch (NumberFormatException e) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid discount ID");
            return;
        }
        Discount discount = ds.getDiscountById(discountId);
        if (isDiscountExpired(discount)) {
            HttpSession session = req.getSession();
            session.setAttribute("expiredMessage", "Chương trình giảm giá đã hết hạn!");
            resp.sendRedirect(req.getContextPath() + "/discount");
            return;
        }

        // Xử lý phân trang
        String pageParam = req.getParameter("page");
        if (pageParam != null && !pageParam.isEmpty()) {
            try {
                currentPage = Integer.parseInt(pageParam);
            } catch (NumberFormatException e) {
                resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid page number");
                return;
            }
        }

        List<Painting> data = null;
        List<Artist> artists = null;
        List<Theme> themes = null;
        List<PaintingSize> paintingSizes = null;
        try {
            String sort = req.getParameter("sort");
            boolean isSortByRating = (sort != null && sort.equals("rating"));
            String keyword = req.getParameter("keyword");
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


            // Lấy danh sách tranh có giảm giá
            data = ds.getPaintingsByDiscountId(
                    discountId, keyword, minPrice, maxPrice, themeArr, artistArr, startDate, endDate, isSortByRating, currentPage, recordsPerPage
            );
            int totalRecords = ds.countPaintingsByDiscountId(
                    discountId, keyword, minPrice, maxPrice, themeArr, artistArr, startDate, endDate
            );
            int totalPages = (int) Math.ceil((double) totalRecords / recordsPerPage);

            // Lấy danh sách nghệ sĩ, chủ đề, kích thước
            artists = as.getAllArtists();
            themes = ts.getAllTheme();
            paintingSizes = ss.getAllSize();

            // Gán dữ liệu vào request
            req.setAttribute("discount", discount);
            req.setAttribute("data", data);
            req.setAttribute("artists", artists);
            req.setAttribute("themes", themes);
            req.setAttribute("paintingSizes", paintingSizes);
            req.setAttribute("currentPage", currentPage);
            req.setAttribute("recordsPerPage", recordsPerPage);
            req.setAttribute("totalPages", totalPages);

        } catch (SQLException e) {
            throw new RuntimeException(e);
        }

        // Chuyển tiếp đến JSP
        req.getRequestDispatcher("user/discount_content.jsp").forward(req, resp);
    }

    private boolean isDiscountExpired(Discount discount) {
        LocalDate currentDate = LocalDate.now();

        LocalDate endDate = discount.getEndDate();

        return currentDate.isAfter(endDate);
    }
}
