package com.example.web.service;


import com.example.web.dao.LogDao;
import com.example.web.dao.model.Level;
import com.example.web.dao.model.Log;
import com.example.web.dao.model.User;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.List;

public class LogService {
    private LogDao logDao = new LogDao();


    public List<Log> getAllLog() throws SQLException {
        return logDao.getAllLog();
    }

    public boolean addLog(String level, HttpServletRequest request,String preData, String flowData) throws SQLException {
        try {
            Level logLevel = Level.valueOf(level.toUpperCase());

            HttpSession session = request.getSession();
            User user = (User) session.getAttribute("user");
            String who = (user != null && user.getUsername() != null) ? user.getUsername() : "anonymous";

            String logWhere = (String)session.getAttribute("fullAddress");

            String resource = request.getRequestURI();

            if (preData == null || preData.isBlank()) {
                preData = "Không xác định";
            }

            Log log = new Log();
            log.setLevel(logLevel);
            log.setLogTime(LocalDateTime.now());
            log.setLogWhere(logWhere);
            log.setResource(resource);
            log.setWho(who);
            log.setPreData(preData);
            log.setFlowData(flowData != null ? flowData : "");

            return logDao.addLog(log);
        } catch (IllegalArgumentException e) {
            System.err.println("Lỗi: Giá trị level không hợp lệ - " + level);
            return false;
        }
    }

    public boolean deleteLog(int id) throws SQLException {
        return logDao.deleteLog(id);
    }
    public Log getLog(int id) throws SQLException {
        return logDao.getDetailLog(id);
    }

}
