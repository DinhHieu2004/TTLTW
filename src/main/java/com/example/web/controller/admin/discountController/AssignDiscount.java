package com.example.web.controller.admin.discountController;

import com.example.web.dao.DiscountDao;
import com.example.web.service.DiscountService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;


@WebServlet("/admin/assignDiscount")
public class AssignDiscount extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String productIdParam = request.getParameter("productId");
        String discountIdParam = request.getParameter("discountId");

        if (productIdParam != null && discountIdParam != null) {
            try {
                int productId = Integer.parseInt(productIdParam);
                int discountId = Integer.parseInt(discountIdParam);

                // Thêm sản phẩm vào chương trình giảm giá
                DiscountService service = new DiscountService();
                boolean success = service.assignProductsToDiscount(productId, discountId);

                // Trả về kết quả dưới dạng JSON
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                if (success) {
                    response.getWriter().write("{\"status\":\"success\",\"message\":\"Thêm sản phẩm vào giảm giá thành công!\"}");
                } else {
                    response.getWriter().write("{\"status\":\"failure\",\"message\":\"Thêm sản phẩm vào giảm giá thất bại.\"}");
                }
            } catch (NumberFormatException | SQLException e) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Dữ liệu không hợp lệ");
            }
        } else {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Thiếu mã sản phẩm hoặc mã giảm giá");
        }
    }
}



