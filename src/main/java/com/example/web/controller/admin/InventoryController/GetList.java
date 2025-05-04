package com.example.web.controller.admin.InventoryController;

import com.example.web.dao.model.Painting;
import com.example.web.dao.model.PaintingSize;
import com.example.web.dao.model.StockIn;
import com.example.web.service.PaintingService;
import com.example.web.service.SizeService;
import com.example.web.service.StockIOService;
import io.opencensus.common.ServerStatsFieldEnums;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/admin/inventoryTrans")
public class GetList extends HttpServlet {
    private final StockIOService stockIOService = new StockIOService();
    private final PaintingService paintingService = new PaintingService();
    private final SizeService sizeService = new SizeService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            List<StockIn> stockIn = stockIOService.getAll();
            List<Painting> p = paintingService.getAll();
            List<PaintingSize> s = sizeService.getAllSize();
            req.setAttribute("stockIn", stockIn);
            req.setAttribute("p", p);
            req.setAttribute("s", s);
            req.getRequestDispatcher("stockIO.jsp").forward(req, resp);
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }
}
