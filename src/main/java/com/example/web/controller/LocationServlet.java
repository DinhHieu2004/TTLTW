package com.example.web.controller;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import jakarta.mail.Session;
import java.io.IOException;

@WebServlet("/location-servlet")
public class LocationServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String lat = req.getParameter("lat");
        String lon = req.getParameter("lon");
        String address = req.getParameter("address");

      //  System.out.println("Tọa độ: " + lat + ", " + lon);
      //  System.out.println("Địa chỉ: " + address);
        String fullAddress = address + ",lat: "+lat+",lon: "+lon;

        HttpSession session = req.getSession();
        session.setAttribute("fullAddress", fullAddress);



        resp.setContentType("text/plain");
        resp.getWriter().write("Ghi log thành công: " + address);
    }

}