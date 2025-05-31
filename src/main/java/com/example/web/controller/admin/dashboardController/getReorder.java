package com.example.web.controller.admin.dashboardController;


import com.example.web.dao.model.ReorderAlert;
import com.example.web.service.AdminService;
import com.example.web.service.ReorderAlertService;
import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/admin/reorder")

public class getReorder extends HttpServlet {
    private final ReorderAlertService reorderAlertService = new ReorderAlertService();
    private final Gson gson = new Gson();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

            try {
                List<ReorderAlert> alerts = reorderAlertService.getReorderAlerts();

                String json = gson.toJson(alerts);
                response.getWriter().write(json);
            } catch (Exception e) {
                e.printStackTrace();
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                response.getWriter().write("{\"error\":\"Có lỗi xảy ra trong quá trình xử lý.\"}");

        }

    }
}
