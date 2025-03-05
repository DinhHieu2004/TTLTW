package com.example.web.controller.admin.OrderController;

import com.example.web.service.ArtistService;
import com.example.web.service.OrderService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/admin/orders/delete")
public class Delete extends HttpServlet {
    private OrderService orderService = new OrderService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        String orderId = request.getParameter("orderId");
        System.out.println(orderId);
        try {
            boolean isDeleted = orderService.deleteOrder(Integer.parseInt(orderId));
            System.out.println(isDeleted);
            if (isDeleted) {

                request.setAttribute("message", "Xóa Đơn hàng thành công!");
            } else {
                request.setAttribute("message", "Xóa Đơn hàng thất bại!");
            }
        } catch (Exception e) {
            request.setAttribute("message", "Lỗi: " + e.getMessage());
        }
        response.sendRedirect("../orders");
        //  request.getRequestDispatcher("../artists.jsp").forward(request, response);
    }


}
