package com.example.web.controller.admin.InventoryController;

import com.example.web.dao.model.StockIn;
import com.example.web.dao.model.StockInItem;
import com.example.web.service.StockIOService;
import com.google.gson.Gson;
import io.leangen.geantyref.TypeToken;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;
import java.lang.reflect.Type;
import java.sql.Date;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/admin/inventoryTrans/addStockIn")
public class AddStockIn extends HttpServlet {
    private final StockIOService stockIOService = new StockIOService();
    private final Gson gson = new Gson();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");
        PrintWriter out = resp.getWriter();
        Map<String, Object> responseMap = new HashMap<>();

        String createdId = req.getParameter("createdId");
        String supplier = req.getParameter("supplier");
        String note = req.getParameter("note");
        String createdDate = req.getParameter("createdDate");
        String productsJson = req.getParameter("products");
        List<StockInItem> products = null;

        if (createdId == null || createdId.isEmpty()) {
            responseMap.put("status", "error");
            responseMap.put("message", "Không tìm thấy ID người thực hiện!");
        } else if (supplier == null || supplier.isEmpty()) {
            responseMap.put("status", "error");
            responseMap.put("message", "Vui lòng nhập nhà cung cấp!");
        } else if (createdDate == null || createdDate.isEmpty()) {
            responseMap.put("status", "error");
            responseMap.put("message", "Vui lòng chọn ngày nhập!");
        } else {
            Type productListType = new TypeToken<List<StockInItem>>(){}.getType();
            products = gson.fromJson(productsJson, productListType);

            if (products == null || products.isEmpty()) {
                responseMap.put("status", "error");
                responseMap.put("message", "Danh sách sản phẩm không được rỗng.");
            } else {
                for (StockInItem product : products) {
                    if (product.getQuantity() <= 0) {
                        responseMap.put("status", "error");
                        responseMap.put("message", "Số lượng phải lớn hơn 0!");
                        break;
                    } else if (product.getSizeId() <= 0) {
                        responseMap.put("status", "error");
                        responseMap.put("message", "Vui lòng chọn kích thước!");
                        break;
                    } else if (product.getPrice() <= 0) {
                        responseMap.put("status", "error");
                        responseMap.put("message", "Giá phải lớn hơn 0");
                        break;
                    }
                }
            }
        }

        if (!responseMap.isEmpty()) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.write(gson.toJson(responseMap));
            return;
        }

        try {
            int creatorId = Integer.parseInt(createdId);
            Date date = Date.valueOf(createdDate);
            double totalPrice = products.stream().mapToDouble(StockInItem::getTotalPrice).sum();
            int supId = Integer.parseInt(supplier);

            StockIn stockIn = new StockIn(0, creatorId, supId, note, totalPrice, date, "Chưa áp dụng");
            stockIn.setListPro(products);

            int stockInId = stockIOService.saveStockInWithItems(stockIn);

            if (stockInId > 0) {
                stockIn = stockIOService.getSIById(stockInId);
                responseMap.put("status", "success");
                responseMap.put("stockIn", stockIn);
                resp.setStatus(HttpServletResponse.SC_OK);
                out.write(gson.toJson(responseMap));
            } else {
                responseMap.put("status", "error");
                responseMap.put("message", "Lưu dữ liệu thất bại.");
                resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                out.write(gson.toJson(responseMap));
            }
        } catch (SQLException e) {
            e.printStackTrace();
            responseMap.put("status", "error");
            responseMap.put("message", "Có lỗi xảy ra khi lưu dữ liệu");
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.write(gson.toJson(responseMap));
        }
    }
}
