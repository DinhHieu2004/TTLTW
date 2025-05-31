package com.example.web.controller.util;

import com.example.web.service.UserService;
import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;

import java.util.Timer;
import java.util.TimerTask;

@WebListener
public class AppStartupListener implements ServletContextListener {
    private Timer timer;

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        timer = new Timer();
        timer.scheduleAtFixedRate(new TimerTask() {
            @Override
            public void run() {
                try {
                    UserService userService = new UserService();
                    userService.updateUsersStatusIfTokenExpired();
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        }, 0, 60 * 60 * 1000);
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        timer.cancel();
    }
}
