package com.example.web.controller.util;

import java.io.InputStream;
import java.util.Properties;

public class ConfigUtil {
    private static final Properties props = new Properties();

    static {
        try (InputStream input = ConfigUtil.class.getClassLoader().getResourceAsStream("config.properties")) {
            if (input != null) {
                props.load(input);
            } else {
                throw new RuntimeException("Không tìm thấy file config.properties");
            }
        } catch (Exception e) {
            throw new RuntimeException("Lỗi khi đọc file cấu hình", e);
        }
    }

    public static String get(String key) {
        return props.getProperty(key);
    }
}

