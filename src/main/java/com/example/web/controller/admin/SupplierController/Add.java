package com.example.web.controller.admin.SupplierController;

import com.example.web.dao.model.Supplier;
import com.example.web.service.SupplierService;
import com.google.gson.Gson;
import com.google.gson.JsonObject;
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

@WebServlet("/admin/supplier/add")
public class Add extends HttpServlet {
    private final SupplierService supplierService = new SupplierService();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");
        Gson gson = new Gson();
        PrintWriter out = resp.getWriter();

        String name = req.getParameter("name");
        String email = req.getParameter("email");
        String phone = req.getParameter("phone");
        String address = req.getParameter("address");

        try {
            if (supplierService.findByEmail(email) != null) {
                Map<String, Object> response = new HashMap<>();
                response.put("status", "error");
                response.put("message", "Email đã tồn tại, vui lòng chọn email khác.");
                out.print(new Gson().toJson(response));
                out.flush();
                return;
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }

        Supplier s = new Supplier();
        s.setName(name);
        s.setEmail(email);
        s.setPhone(phone);
        s.setAddress(address);

        Supplier inserted = null;
        try {
            inserted = supplierService.addSupplier(s);
        } catch (SQLException e) {
            e.printStackTrace();
        }

        if (inserted != null) {
            Map<String, Object> response = new HashMap<>();
            response.put("status", "success");
            response.put("supplier", inserted);
            out.print(gson.toJson(response));
        } else {
            Map<String, Object> response = new HashMap<>();
            response.put("status", "error");
            response.put("message", "Không thể thêm nhà cung cấp.");
            out.print(gson.toJson(response));
        }
        out.flush();
    }
}
