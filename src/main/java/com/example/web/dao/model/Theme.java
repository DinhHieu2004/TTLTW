package com.example.web.dao.model;

import java.io.Serializable;

public class Theme implements Serializable {
    private int id;
    private String themeName;

    public Theme(int id, String themeName) {
        this.id = id;
        this.themeName = themeName;
    }

    public Theme() {

    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getThemeName() {
        return themeName;
    }

    public void setThemeName(String themeName) {
        this.themeName = themeName;
    }

    @Override
    public String toString() {
        return "Theme{" +
                "id=" + id +
                ", ThemeName='" + themeName + '\'' +
                '}';
    }
}
