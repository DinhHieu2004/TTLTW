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
import java.util.Map;

@WebServlet("/admin/supplier/update")
public class Update extends HttpServlet {
    private final SupplierService supplierService = new SupplierService();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");
        Gson gson = new Gson();
        PrintWriter out = resp.getWriter();

        int id = Integer.parseInt(req.getParameter("id"));
        String name = req.getParameter("name");
        String email = req.getParameter("email");
        String phone = req.getParameter("phone");
        String address = req.getParameter("address");

        try {
            Supplier existing = supplierService.getSupplierById(id);
            if (existing == null) {
                out.print(gson.toJson(Map.of("status", "error", "message", "Nhà cung cấp không tồn tại.")));
                out.flush();
                return;
            }

            if (!existing.getEmail().equals(email)) {
                Supplier byEmail = supplierService.findByEmail(email);
                if (byEmail != null && byEmail.getId() != id) {
                    out.print(gson.toJson(Map.of("status", "error", "message", "Email đã tồn tại.")));
                    out.flush();
                    return;
                }
            }

            existing.setName(name);
            existing.setEmail(email);
            existing.setPhone(phone);
            existing.setAddress(address);

            boolean success = supplierService.updateSupplier(existing);
            if (success) {
                out.print(gson.toJson(Map.of("status", "success", "supplier", existing)));
            } else {
                out.print(gson.toJson(Map.of("status", "error", "message", "Cập nhật thất bại.")));
            }
        } catch (SQLException e) {
            e.printStackTrace();
            out.print(gson.toJson(Map.of("status", "error", "message", "Lỗi hệ thống.")));
        }

        out.flush();
    }
}

