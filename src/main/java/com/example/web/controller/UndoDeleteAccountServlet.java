package com.example.web.controller;

import com.example.web.dao.model.User;
import com.example.web.dao.model.UserToken;
import com.example.web.service.AuthService;
import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

@WebServlet("/undo-delete")
public class UndoDeleteAccountServlet extends HttpServlet {
    private final AuthService authService = new AuthService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String token = req.getParameter("token");
        String status;

        if (token == null || token.isEmpty()) {
            status = "INVALID_TOKEN";
        } else {
            try {
                UserToken userToken = authService.findByToken(token, "undoDelete");
                if (userToken == null) {
                    status = "TOKEN_NOT_FOUND";
                } else if (userToken.getExpiredAt().before(new Timestamp(System.currentTimeMillis()))) {
                    status = "TOKEN_EXPIRED";
                } else {
                    User user = authService.findById(userToken.getUserId());
                    if (!"Chờ xóa".equals(user.getStatus())) {
                        status = "INVALID_STATUS";
                    } else {
                        boolean isUndoSuccess = authService.undoDeleteUserByToken(token, user.getId());
                        status = isUndoSuccess ? "SUCCESS" : "UNDO_FAILED";
                    }
                }
            } catch (SQLException e) {
                e.printStackTrace();
                status = "ERROR";
            }
        }
        req.setAttribute("status", status);
        req.getRequestDispatcher("/user/undoDelete.jsp").forward(req, resp);
    }
}
