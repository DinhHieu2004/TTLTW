package com.example.web.controller.admin.SupplierController;


import com.example.web.service.SupplierService;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;

@WebServlet("/admin/supplier/delete")
public class Delete extends HttpServlet {
    private final SupplierService supplierService = new SupplierService();
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();

        try {
            int id = Integer.parseInt(request.getParameter("id"));

            boolean deleted = supplierService.deleteSupplier(id);

            if (deleted) {
                out.write("{\"status\": \"success\"}");
            } else {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.write("{\"status\": \"fail\", \"message\": \"Không thể xoá nhà cung cấp.\"}");
            }
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.write("{\"status\": \"error\", \"message\": \"" + e.getMessage() + "\"}");
        }
    }
}
