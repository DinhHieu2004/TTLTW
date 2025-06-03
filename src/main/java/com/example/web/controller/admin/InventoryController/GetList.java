package com.example.web.controller.admin.InventoryController;

import com.example.web.dao.model.*;
import com.example.web.service.OrderService;
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
import java.util.Comparator;
import java.util.List;

@WebServlet("/admin/inventoryTrans")
public class GetList extends HttpServlet {
    private final StockIOService stockIOService = new StockIOService();
    private final PaintingService paintingService = new PaintingService();
    private final SizeService sizeService = new SizeService();
    private final OrderService orderService = new OrderService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            List<StockIn> stockIn = stockIOService.getAll();
            List<StockOut> stockOut = stockIOService.getAllOut();
            List<Painting> p = paintingService.getAll();
            List<PaintingSize> s = sizeService.getAllSize();
            List<Order> o = orderService.getOrderByDelStatus("Chờ");
            req.setAttribute("stockIn", stockIn);
            req.setAttribute("stockOut", stockOut);
            p.sort(Comparator.comparingInt(Painting::getId));
            req.setAttribute("p", p);
            req.setAttribute("s", s);
            req.setAttribute("o", o);
            req.getRequestDispatcher("stockIO.jsp").forward(req, resp);
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }
}
