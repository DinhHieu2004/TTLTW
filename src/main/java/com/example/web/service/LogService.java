package com.example.web.service;


import com.example.web.dao.LogDao;
import com.example.web.dao.model.Level;
import com.example.web.dao.model.Log;

import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.List;

public class LogService {
    private LogDao logDao = new LogDao();


    public List<Log> getAllLog() throws SQLException {
        return logDao.getAllLog();
    }

    public boolean addLog(String level , String logWhere, String resource, String who, String preData, String flowData) throws SQLException {
        try {
            Level logLevel = Level.valueOf(level.toUpperCase());

            if (who == null || who.isBlank()) {
                who = "anonymous";
            }

            Log log = new Log();
            log.setLevel(logLevel);
            log.setLogTime( LocalDateTime.now());
            log.setLogWhere(logWhere != null ? logWhere : "");
            log.setResource(resource != null ? resource : "");
            log.setWho(who);
            log.setPreData(preData != null ? preData : "");
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
}
