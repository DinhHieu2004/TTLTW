package com.example.web.controller.admin.logsController;

import com.example.web.controller.util.GsonProvider;
import com.example.web.dao.model.Log;
import com.example.web.service.LogService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/admin/logs/detail")
public class GetDetail extends HttpServlet {
    private LogService logService;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        logService = new LogService();

        int id = Integer.parseInt(req.getParameter("logId"));

        try {
            resp.setContentType("application/json");
            resp.setCharacterEncoding("utf-8");
            Log l = logService.getLog(id);

            if(l !=null){
                resp.getWriter().write(GsonProvider.getGson().toJson(l));
            }else{
                resp.getWriter().write(GsonProvider.getGson().toJson("log not exist"));
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }
}
