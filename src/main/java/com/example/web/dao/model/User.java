package com.example.web.dao.model;

import java.io.Serializable;

public class User  implements Serializable {
    private int id;
    private String google_id;
    private String fullName;
    private String username;
    private String address;
    private String email;
    private String phone;
    private Role role;
    private String password;

    public User(int id, String fullName, String username, String address, String email, String phone, Role role) {
        this.id = id;
        this.fullName = fullName;
        this.username = username;
        this.address = address;
        this.email = email;
        this.phone = phone;
        this.role = role;
    }
    public User(int id, String fullName, String username, String address, String email, String phone, Role role, String password) {
        this.id = id;
        this.fullName = fullName;
        this.username = username;
        this.address = address;
        this.email = email;
        this.phone = phone;
        this.role = role;
        this.password = password;
    }
    public User(int id, String google_id, String fullName, String email, Role role){
        this.id = id;
        this.google_id = google_id;
        this.fullName = fullName;
        this.email = email;
        this.role = role;
    }

    public User() {

    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    @Override
    public String toString() {
        return "User{" +
                "id=" + id +
                ", fullName='" + fullName + '\'' +
                ", username='" + username + '\'' +
                ", address='" + address + '\'' +
                ", email='" + email + '\'' +
                ", phone='" + phone + '\'' +
                ", role=" + role +
                '}';
    }

    public enum Role {
        admin,
        user
    }

    public int getId() {
        return id;
    }

    public String getFullName() {
        return fullName;
    }

    public String getUsername() {
        return username;
    }


    public String getAddress() {
        return address;
    }

    public String getEmail() {
        return email;
    }

    public String getPhone() {
        return phone;
    }

    public Role getRole() {
        return role;
    }

    public void setId(int id) {
        this.id = id;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public void setUsername(String username) {
        this.username = username;
    }


    public void setAddress(String address) {
        this.address = address;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public void setRole(Role role) {
        this.role = role;
    }

    public String getGoogle_id() {
        return google_id;
    }

    public void setGoogle_id(String google_id) {
        this.google_id = google_id;
    }
}

