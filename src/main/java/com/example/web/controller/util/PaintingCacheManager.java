package com.example.web.controller.util;

import com.github.benmanes.caffeine.cache.Cache;
import com.github.benmanes.caffeine.cache.Caffeine;

import java.time.Duration;
import java.util.List;
import com.example.web.dao.model.Painting;

public class PaintingCacheManager {
    private static final Cache<String, List<Painting>> paintingListCache = Caffeine.newBuilder()
            .expireAfterWrite(Duration.ofMinutes(10))
            .maximumSize(100)
            .build();

    public static List<Painting> getCached(String key) {
        return paintingListCache.getIfPresent(key);
    }

    public static void put(String key, List<Painting> data) {
        paintingListCache.put(key, data);
    }

    public static void clear(String key) {
        paintingListCache.invalidate(key);
    }

    public static void clearAll() {
        paintingListCache.invalidateAll();
    }
}
