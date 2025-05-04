package com.example.web.controller.util;

import com.example.web.dao.model.User;

public class CheckPermission {


    public static boolean checkPermission(User user, String permissions, String role) {
        boolean result = false;
        String allPermission = user.getAllRolePermission();

        role = "ROLE_" + role;

        String p[] = allPermission.split(" ");
         for(String p1 : p) {
             if(p1.equals(permissions) ||  p1.equals(role)) {
                 result = true;
             }
         }
        return result;
    }


}
