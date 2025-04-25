package com.example.web.utils;

import jakarta.servlet.annotation.WebListener;
import jakarta.servlet.http.HttpSessionEvent;
import jakarta.servlet.http.HttpSessionListener;

@WebListener
public class SessionCleanupListener implements HttpSessionListener {
    @Override
    public void sessionDestroyed(HttpSessionEvent se) {
        String uid = (String) se.getSession().getAttribute("uid");
        if (uid != null) {
            SessionManager.userSessions.remove(uid);
        }
    }
}
