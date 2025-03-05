package com.example.web.dao.db;


import java.sql.*;

public class DbConnect {
    static String url = "jdbc:mysql://" + DbProperties.host() + ":" + DbProperties.port() + "/" + DbProperties.dbname() + "?" + DbProperties.option();
    static Connection conn;
    private static final ThreadLocal<Connection> threadLocal = new ThreadLocal<>();

    public static Connection getConnection() {
        try {
            if (conn == null || conn.isClosed()) {
                conn = makeConnect();
                threadLocal.set(conn);
            }
            return conn;
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            return null;
        }
    }



    private static Connection makeConnect() throws ClassNotFoundException, SQLException {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn = DriverManager.getConnection(url, DbProperties.Username(), DbProperties.password());
        if (conn != null) {
            System.out.println("Connection established successfully.");
        } else {
            System.out.println("Failed to establish connection.");
        }
        return conn;
    }

    public static void main(String[] args) throws SQLException {
        System.out.println(getConnection());

    }
}
