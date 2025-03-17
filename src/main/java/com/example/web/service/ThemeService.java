package com.example.web.service;

import com.example.web.dao.ThemeDao;
import com.example.web.dao.model.Theme;

import java.sql.SQLException;
import java.util.List;

public class ThemeService {
    ThemeDao themeDao= new ThemeDao();

    public ThemeService(){}

    public List<Theme> getAllTheme() throws SQLException {
        return themeDao.getAllTheme();
    }

    public boolean addTheme(String themeName) throws SQLException {
        return themeDao.addTheme(themeName);
    }
    public boolean updateTheme(int id, String themeName) throws SQLException {
        return themeDao.updateTheme(id, themeName);
    }
    public boolean deleteTheme(int id) throws SQLException {
        return themeDao.deleteTheme(id);
    }
    public Theme getThemeById(int id) throws SQLException {
        return themeDao.getThemeById(id);
    }
    public int getLastInsertedId() throws SQLException {
        return themeDao.getLastInsertedId();
    }


}
