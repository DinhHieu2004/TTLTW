package com.example.web.dao.model;

import java.util.HashSet;
import java.util.Set;

public class Role implements java.io.Serializable {
    private int id;
    private String name;
    private Set<Permission> permissions = new HashSet<Permission>();


    public Role(String name) {
        this.name = name;
    }
    public Role(){

    }
    public Role(int id, String name) {
        this.id = id;
        this.name = name;
    }

    public Role(int roleId, String roleName, Set<Permission> permissions) {
        this.id = roleId;
        this.name = roleName;
        this.permissions = permissions;

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

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public void setName(String name) {
        this.name = name;
    }

    public void setPermissions(Set<Permission> permissions) {
        this.permissions = permissions;
    }

    @Override
    public String toString() {
        return "Role{" +
                "id=" + id +
                ", name='" + name + '\'' +
                ", permissions=" + permissions +
                '}';
    }
}
