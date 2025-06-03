package com.example.web.dao.db;


import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

public class DbProperties {
    private static final Properties prod = new Properties();

    static {
        try (InputStream input = DbProperties.class.getClassLoader().getResourceAsStream("db.properties")) {
            if (input == null) {
                throw new RuntimeException("db.properties not found in classpath");
            }
            prod.load(input);
        } catch (IOException e) {
            throw new RuntimeException("Failed to load db.properties", e);
        }
    }

    public static String host() {
        return get("db.host");
    }

    public static int port() {
        try {
            return Integer.parseInt(get("db.port"));
        } catch (NumberFormatException e) {
            return 3306;
        }
    }

    public static String username() {
        return get("db.user");
    }

    public static String password() {
        return get("db.password");
    }

    public static String dbname() {
        return get("db.dbname");
    }

    public static String option() {
        return get("db.option");
    }

    private static String get(String key) {
        String value = prod.getProperty(key);
        if (value == null) {
            throw new RuntimeException("⚠️ Missing key in db.properties: " + key);
        }
        return value;
    }
}
