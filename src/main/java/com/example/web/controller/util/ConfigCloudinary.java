package com.example.web.controller.util;

import com.cloudinary.Cloudinary;

import java.util.HashMap;
import java.util.Map;

public class ConfigCloudinary {
    private static Cloudinary cloudinary;

    static {
        Map<String, String> config = new HashMap<>();
        config.put("cloud_name", "dz32nqnp3");
        config.put("api_key", "535356454445185");
        config.put("api_secret", "RgLQQ17SP4en8Zcq1vxYeldQ7yI");

        cloudinary = new Cloudinary(config);
    }

    public static Cloudinary getInstance() {
        return cloudinary;
    }
}
