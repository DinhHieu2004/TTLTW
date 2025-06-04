package com.example.web.controller.admin.SupplierController;

import com.example.web.dao.model.Supplier;
import com.example.web.service.SupplierService;
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
import java.util.Map;

@WebServlet("/admin/supplier/detail")
public class GetDetail extends HttpServlet {
    private final SupplierService supplierService = new SupplierService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");
        PrintWriter out = resp.getWriter();
        Gson gson = new Gson();

        String idParam = req.getParameter("id");
        Map<String, Object> response = new HashMap<>();

        try {
            if (idParam == null) {
                response.put("status", "error");
                response.put("message", "Thiếu ID nhà cung cấp.");
                out.print(gson.toJson(response));
                return;
            }

            int id = Integer.parseInt(idParam);
            Supplier supplier = supplierService.getSupplierById(id);

            if (supplier != null) {
                response.put("status", "success");
                response.put("supplier", supplier);
            } else {
                response.put("status", "error");
                response.put("message", "Không tìm thấy nhà cung cấp.");
            }
        } catch (NumberFormatException e) {
            response.put("status", "error");
            response.put("message", "ID không hợp lệ.");
        } catch (SQLException e) {
            e.printStackTrace();
            response.put("status", "error");
            response.put("message", "Lỗi cơ sở dữ liệu.");
        }

        out.print(gson.toJson(response));
        out.flush();
    }
}

