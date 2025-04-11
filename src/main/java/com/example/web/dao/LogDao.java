package com.example.web.dao;

import com.example.web.dao.db.DbConnect;
import com.example.web.dao.model.Level;
import com.example.web.dao.model.Log;

import java.sql.*;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;

public class LogDao {

    static Connection conn = DbConnect.getConnection();
    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");


    public List<Log> getAllLog() throws SQLException {
        List<Log> logs = new ArrayList<>();
        String sql = "select * from log";
        PreparedStatement ps = conn.prepareStatement(sql);
        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
            int id = rs.getInt("id");
            String level = rs.getString("level");
            LocalDateTime logTime = LocalDateTime.parse(rs.getString("logTime"),formatter);
            String logWhere = rs.getString("logWhere");
            String resource = rs.getString("resource");
            String who = rs.getString("who");
            String preData = rs.getString("preData");
            String flowData = rs.getString("flowData");
            Log log = new Log(id, Level.valueOf(level), logTime,logWhere,resource,who,preData,flowData);
            logs.add(log);
        }
        return logs;
    }

    public boolean addLog(Log log) throws SQLException {

        String sql = "INSERT INTO log (level, logTime, logWhere, resource, who, preData, flowData) VALUES (?,?,?,?,?,?,?)";
        PreparedStatement statement = conn.prepareStatement(sql);
        statement.setString(1, log.getLevel());
        statement.setTimestamp(2, Timestamp.valueOf(log.getLogTime()));
        statement.setString(3, log.getLogWhere());
        statement.setString(4, log.getResource());
        statement.setString(5, log.getWho());
        statement.setString(6, log.getPreData());
        statement.setString(7, log.getFlowData());
        int rowsInserted = statement.executeUpdate();
        return rowsInserted > 0;

    }



    public boolean deleteLog(int i) throws SQLException {
        String query = "delete from log where id = ?";
        try (PreparedStatement preparedStatement = conn.prepareStatement(query)) {
            preparedStatement.setInt(1, i);
            int rowsAffected = preparedStatement.executeUpdate();
            return rowsAffected > 0;
        }
    }
    public Log getDetailLog(int id) throws SQLException {
        String sql = "select * from log where id = ?";

        PreparedStatement statement = conn.prepareStatement(sql);

        statement.setInt(1, id);
        ResultSet rs = statement.executeQuery();
        if (rs.next()) {
            String level = rs.getString("level");
            LocalDateTime logTime = LocalDateTime.parse(rs.getString("logTime"), formatter);
            String logWhere = rs.getString("logWhere");
            String resource = rs.getString("resource");
            String who = rs.getString("who");
            String preData = rs.getString("preData");
            String flowData = rs.getString("flowData");

            Level levelEnum = Level.valueOf(level);
            return new Log(id,levelEnum, logTime,logWhere,resource,who,preData,flowData);
        }
        return null;

    }

    public static void main(String[] args) throws SQLException {
        LogDao l = new LogDao();
        System.out.println(l.getAllLog());
    }

}
