package com.example.web.dao.model;

import java.io.Serializable;
import java.util.HashSet;
import java.util.Set;
import com.example.web.dao.model.Role;

public class User  implements Serializable {
    private int id;
    private String gg_id;
    private String fb_id;
    private String fullName;
    private String username;
    private String address;
    private String email;
    private String phone;
    //private Role role;
    private String password;
    private Set<Role> roles = new HashSet<>();
    private String allRolePermission;


    public String getAllRolePermission() {
        String result="";
        for(Role role : roles) {
            result+= "ROLE_"+role.getName()+" ";
            for(Permission permission : role.getPermissions()) {
                result+= permission.getName()+" ";
            }
        }
        this.allRolePermission = result;
        return allRolePermission;
    }
    public User(int id, String fullName, String username, String address, String email, String phone) {
        this.id = id;
        this.fullName = fullName;
        this.username = username;
        this.address = address;
        this.email = email;
        this.phone = phone;
       // this.role = role;
    }

    public User(int id, String fullName, String username, String address, String email, String phone, String password) {
        this.id = id;
        this.fullName = fullName;
        this.username = username;
        this.address = address;
        this.email = email;
        this.phone = phone;
        this.password = password;
    }
    public User(int id, String fullName, String username, String address, String email, String phone,String password, Set<Role> roles) {
        this.id = id;
        this.fullName = fullName;
        this.username = username;
        this.address = address;
        this.email = email;
        this.phone = phone;
        this.roles = roles;
        this.password = password;
    }
    public User(int id, String gg_id, String fb_id, String fullName, String email, Set<Role> role){
        this.id = id;
        this.gg_id = gg_id;
        this.fb_id = fb_id;
        this.fullName = fullName;
        this.email = email;
        this.roles = role;
    }
    public User() {

    }
    public void addRole(Role role) {
        roles.add(role);
    }
    public void setRole(Set<Role> roles) {
        this.roles = roles;
    }

    public Set<Role> getRoles() {
        return roles;
    }
    public Set<Permission> getAllPermissions() {
        Set<Permission> allPermissions = new HashSet<>();
        for (Role r : roles) {
            allPermissions.addAll(r.getPermissions());
        }
        return allPermissions;
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
                ", password='" + password + '\'' +
                ", roles=" + roles +
                '}';
    }

    // public enum Role {
   //     admin,
  //      user
   // }

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

  //  public Role getRole() {
    //    return role;
 //   }

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

    public boolean hasPermission(String permission) {
        return roles.stream()
                .flatMap(role -> role.getPermissions().stream())
                .map(Permission::getName)
                .anyMatch(name -> name.equals(permission));
    }

    // public void setRole(Role role) {
     //   this.role = role;
   // }

    public static void main(String[] args) {
    }

    public String getGg_id() {
        return gg_id;
    }

    public void setGg_id(String gg_id) {
        this.gg_id = gg_id;
    }

    public String getFb_id() {
        return fb_id;
    }

    public void setFb_id(String fb_id) {
        this.fb_id = fb_id;
    }
}

