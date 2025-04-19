package com.example.web.controller.admin.logsController;


import com.example.web.controller.util.CheckPermission;
import com.example.web.dao.model.Log;
import com.example.web.dao.model.User;
import com.example.web.service.LogService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/admin/logs")
public class GetList extends HttpServlet {
    private LogService logService;
    private final String permission = "VIEW_LOGS";

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        logService = new LogService();

        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("user");

        boolean hasPermission = CheckPermission.checkPermission(user, permission, "ADMIN");
        if (!hasPermission) {
            resp.sendRedirect(req.getContextPath() + "/NoPermission.jsp");
            return;
        }
        try {
            List<Log> logs = logService.getAllLog();
            req.setAttribute("logs", logs);
            req.getRequestDispatcher("logs.jsp").forward(req, resp);

        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }
}
