package com.example.web.dao.model;

import java.util.HashSet;
import java.util.Set;

public class Role {
    private int id;
    private String name;
    private Set<Permission> permissions = new HashSet<Permission>();


    public Role(String name) {
        this.name = name;
    }
    public Role(){

    }

    public void addPermission(Permission permission) {
        permissions.add(permission);
    }

    public Set<Permission> getPermissions() {
        return permissions;
    }

    public String getName() {
        return name;
    }
}
