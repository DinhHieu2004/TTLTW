package com.example.web.controller.admin.InventoryController;

import com.example.web.service.OrderService;
import com.example.web.service.PaintingService;
import com.example.web.service.StockIOService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;


@WebServlet("/admin/inventoryTrans/applied")
public class Applied extends HttpServlet {
    private final StockIOService stockIOService = new StockIOService();
    private final OrderService orderService = new OrderService();

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
            boolean isApplied;
            if ("in".equalsIgnoreCase(type)) {
                if ("Đã áp dụng".equals(stockIOService.getSIById(Integer.parseInt(id)).getStatus())) {
                    resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    resp.getWriter().write("{\"error\": \"Phiếu nhập kho đã được áp dụng.\"}");
                    return;
                }
                isApplied = stockIOService.applyStockInById(id);
                if (isApplied) {
                    resp.setStatus(HttpServletResponse.SC_OK);
                    resp.getWriter().write("{\"success\": \"Phiếu nhập kho đã được áp dụng thành công.\"}");
                } else {
                    resp.setStatus(HttpServletResponse.SC_NOT_FOUND);
                    resp.getWriter().write("{\"error\": \"Không tìm thấy phiếu nhập kho để áp dụng.\"}");
                }
            } else if ("out".equalsIgnoreCase(type)) {
                if ("Đã áp dụng".equals(stockIOService.getSOById(Integer.parseInt(id)).getStatus())) {
                    resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    resp.getWriter().write("{\"error\": \"Phiếu nhập kho đã được áp dụng.\"}");
                    return;
                }
                boolean isDelivery = stockIOService.getSOById(Integer.parseInt(id)).getReason().equals("Giao hàng");
                if(isDelivery && !orderService.isPendingOrder(stockIOService.getSOById(Integer.parseInt(id)).getOrderId())){
                    resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    resp.getWriter().write("{\"error\": \"Đơn hàng không hợp lệ.\"}");
                    return;
                }
                List<String> insufficientItems = stockIOService.getInsufficientStockItems(id);
                if (!insufficientItems.isEmpty()) {
                    resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    String message = String.join(", ", insufficientItems);
                    resp.getWriter().write("{\"error\": \"Không đủ tồn kho cho các sản phẩm: " + message + "\"}");
                    return;
                }
                isApplied = stockIOService.applyStockOutById(id);
                if (isApplied) {
                    resp.setStatus(HttpServletResponse.SC_OK);
                    resp.getWriter().write("{\"success\": \"Phiếu xuất kho đã được áp dụng.\"}");
                } else {
                    resp.setStatus(HttpServletResponse.SC_NOT_FOUND);
                    resp.getWriter().write("{\"error\": \"Không tìm thấy phiếu xuất kho để áp dụng.\"}");
                }

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
