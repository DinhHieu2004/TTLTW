package com.example.web.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;

@WebServlet("/api/shipping-fee")
public class ShippingFeeServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String province = request.getParameter("province");
        String district = request.getParameter("district");
        String address = request.getParameter("address");

        String url = "https://services.giaohangtietkiem.vn/services/shipment/fee?pick_province=Hà Nội&pick_district=Quận Hai Bà Trưng&province=" + URLEncoder.encode(province, "UTF-8") + "&district=" + URLEncoder.encode(district, "UTF-8") + "&address=" + URLEncoder.encode(address, "UTF-8") + "&weight=1000&value=3000000";
        HttpURLConnection conn = (HttpURLConnection) new URL(url).openConnection();
        conn.setRequestMethod("GET");
        conn.setRequestProperty("Token", "1L59F1G13YAy3rlL2pLioLZLxaYV14ifJgQt4Et");

        BufferedReader in = new BufferedReader(new InputStreamReader(conn.getInputStream()));
        StringBuilder jsonResponse = new StringBuilder();
        String line;
        while ((line = in.readLine()) != null) {
            jsonResponse.append(line);
        }
        in.close();

        response.setContentType("application/json");
        response.getWriter().write(jsonResponse.toString());
    }
}
