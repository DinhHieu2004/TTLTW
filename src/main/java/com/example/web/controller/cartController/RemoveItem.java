package com.example.web.controller.cartController;

import com.example.web.dao.cart.Cart;
import com.example.web.dao.cart.CartPainting;
import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet(name="RemoveFromCart", value = "/remove-from-cart")
public class RemoveItem extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String productId = req.getParameter("productId");
        String sizeId = req.getParameter("sizeId");

        HttpSession session = req.getSession();
        Cart cart = (Cart) session.getAttribute("cart");


        if (cart != null) {
            cart.removeFromCart(productId, sizeId);
            session.setAttribute("cart", cart);
        }
        System.out.println("productId: " + productId + ", sizeId: " + sizeId);
        System.out.println("Cart: " + cart);


        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");
        String jsonResponse = new Gson().toJson(cart);
        resp.getWriter().write("{\"status\": \"success\", \"cart\": " + jsonResponse + "}");
    }
}
