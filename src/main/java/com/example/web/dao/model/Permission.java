package com.example.web.dao.model;

import java.util.Set;

public class Permission implements java.io.Serializable {
    private int id;
    private String name;
    private String description;

    public Permission(){

    }
    public Permission(int id, String name) {
        this.id = id;
        this.name = name;

    }
    public Permission(int id, String name, String description) {
        this.id = id;
        this.name = name;
        this.description = description;

    }

    public Permission(int permId) {
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

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    @Override
    public String toString() {
        return "Permission{" +
                "id=" + id +
                ", name='" + name + '\'' +
                ", description='" + description + '\'' +
                '}';
    }
}
