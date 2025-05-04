package com.example.web.controller.admin.InventoryController;

import com.example.web.controller.util.GsonProvider;
import com.example.web.dao.model.StockIn;
import com.example.web.service.StockIOService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/admin/inventoryTrans/detail")
public class GetDetail extends HttpServlet {
    private final StockIOService stockIOService = new StockIOService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String type = req.getParameter("type");
        String id = req.getParameter("id");

        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");

        if (type == null || id == null) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            resp.getWriter().write("{\"error\": \"Thiếu dữ liệu.\"}");
            return;
        }

        try {
            Object detail = null;
            if ("in".equalsIgnoreCase(type)) {
                detail = stockIOService.getStockInDetail(id);
            } else if ("out".equalsIgnoreCase(type)) {
                detail = stockIOService.getStockOutDetail(id);
            } else {
                resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                resp.getWriter().write("{\"error\": \"Wrong.\"}");
                return;
            }
            resp.setStatus(HttpServletResponse.SC_OK);
            resp.getWriter().write(GsonProvider.getGson().toJson(detail));
        } catch (Exception e) {
            e.printStackTrace();
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            resp.getWriter().write("{\"error\": \"Internal server error.\"}");
        }
    }
}
