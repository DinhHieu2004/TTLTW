package com.example.web.controller.cartController;


import com.example.web.dao.cart.Cart;
import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/update-quantity")
public class UpdateQuantity extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            String productId = request.getParameter("productId");
            String sizeId = request.getParameter("sizeId");
            int newQuantity = Integer.parseInt(request.getParameter("newQuantity"));
            Cart cart = (Cart) request.getSession().getAttribute("cart");
            boolean isUpdated = cart.upDateCartQuantity(productId, sizeId, newQuantity);


            if (isUpdated) {
                response.setContentType("application/json");
                response.getWriter().write(new Gson().toJson(cart));
            } else {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Cập nhật số lượng thất bại.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }
}
