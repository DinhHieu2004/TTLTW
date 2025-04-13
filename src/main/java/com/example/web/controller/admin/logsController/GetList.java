package com.example.web.controller.admin.logsController;


import com.example.web.dao.model.Log;
import com.example.web.service.LogService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/admin/logs")
public class GetList extends HttpServlet {
    private LogService logService;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        logService = new LogService();

        try {
            List<Log> logs = logService.getAllLog();
            req.setAttribute("logs", logs);
            req.getRequestDispatcher("logs.jsp").forward(req, resp);

        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }
}
