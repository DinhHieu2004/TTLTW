package com.example.web.controller.admin.logsController;

import com.example.web.controller.util.CheckPermission;
import com.example.web.dao.model.User;
import com.example.web.service.LogService;
import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Map;

@WebServlet("/admin/logs/delete")
public class Delete extends HttpServlet {

    LogService logService = new LogService();
    private final String permission ="DELETE_LOGS";


    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        PrintWriter out = response.getWriter();
        Gson gson = new Gson();
        Map<String, Object> jsonResponse = new HashMap<>();


        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        boolean hasPermission = CheckPermission.checkPermission(user, permission, "ADMIN");
        if (!hasPermission) {
            jsonResponse.put("message", "bạn khong có quyền!");
            return;
        }

        String id = request.getParameter("logId");
        System.out.println(id);

        try {
            boolean isDeleted = logService.deleteLog(Integer.parseInt(id));
            if (isDeleted) {
                jsonResponse.put("status", "success");
                jsonResponse.put("message", "Xóa log thành công!");
            } else {
                jsonResponse.put("status", "error");
                jsonResponse.put("message", "Xóa log thất bại!");
            }
        } catch (Exception e) {
            jsonResponse.put("status", "error");
            jsonResponse.put("message", "Lỗi: " + e.getMessage());
        }

        out.print(gson.toJson(jsonResponse));
        out.flush();
    }

}
