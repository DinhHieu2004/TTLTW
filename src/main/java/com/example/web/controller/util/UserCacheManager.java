package com.example.web.controller.util;

import com.example.web.dao.model.User;
import com.github.benmanes.caffeine.cache.Cache;
import com.github.benmanes.caffeine.cache.Caffeine;

import java.time.Duration;
import java.util.List;

public class UserCacheManager {
    private static final UserCacheManager instance = new UserCacheManager();
    private final Cache<Integer, User> userByIdCache;
    private final Cache<String, List<User>> allUsersCache;

    public UserCacheManager() {
        userByIdCache = Caffeine.newBuilder()
                .expireAfterWrite(Duration.ofMinutes(10))
                .maximumSize(1000)
                .build();

        allUsersCache = Caffeine.newBuilder()
                .expireAfterWrite(Duration.ofMinutes(5))
                .maximumSize(1)
                .build();
    }
    public static UserCacheManager getInstance() {
        return instance;
    }

    // ====== Cache theo ID =======
    public User getUserById(int userId) {
        return userByIdCache.getIfPresent(userId);
    }

    public void putUser(User user) {
        userByIdCache.put(user.getId(), user);
    }

    public void invalidateUser(int userId) {
        userByIdCache.invalidate(userId);
    }

    public void invalidateAllUsersById() {
        userByIdCache.invalidateAll();
    }

    public List<User> getAllUsers() {
        return allUsersCache.getIfPresent("all_users");
    }

    public void putAllUsers(List<User> users) {
        allUsersCache.put("all_users", users);
    }

    public void invalidateAllUsersList() {
        allUsersCache.invalidate("all_users");
    }

    public void invalidateEverything() {
        userByIdCache.invalidateAll();
        allUsersCache.invalidateAll();
    }
}
