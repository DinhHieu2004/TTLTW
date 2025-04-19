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

@WebServlet("/admin/inventoryTrans/delete")
public class Delete extends HttpServlet {
    private final StockIOService stockIOService = new StockIOService();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
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
            if ("in".equalsIgnoreCase(type)) {
                boolean isDeleted = stockIOService.deleteStockInById(id);
                if (isDeleted) {
                    resp.setStatus(HttpServletResponse.SC_OK);
                    resp.getWriter().write("{\"success\": \"Phiếu nhập kho đã được xóa.\"}");
                } else {
                    resp.setStatus(HttpServletResponse.SC_NOT_FOUND);
                    resp.getWriter().write("{\"error\": \"Không tìm thấy phiếu nhập kho để xóa.\"}");
                }
            } else if ("out".equalsIgnoreCase(type)) {

            } else {
                resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                resp.getWriter().write("{\"error\": \"Loại yêu cầu không hợp lệ.\"}");
            }
        } catch (Exception e) {
            e.printStackTrace();
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            resp.getWriter().write("{\"error\": \"Lỗi máy chủ nội bộ.\"}");
        }
    }
}
