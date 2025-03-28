package com.example.web.dao.model;

import java.util.Set;

public class Permission {
    private int id;
    private String name;
    private Set<String> allowedApis;

    public Permission(){

    }
    public Permission(int id, String name, Set<String> allowedApis) {
        this.id = id;
        this.name = name;
        this.allowedApis = allowedApis;

    }
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }
    public Set<String> getAllowedApis() {
        return allowedApis;
    }
    public void setAllowedApis(Set<String> allowedApis) {
        this.allowedApis = allowedApis;
    }

    @Override
    public String toString() {
        return "Permission{" +
                "id=" + id +
                ", name='" + name + '\'' +
                ", allowedApis=" + allowedApis +
                '}';
    }
}
