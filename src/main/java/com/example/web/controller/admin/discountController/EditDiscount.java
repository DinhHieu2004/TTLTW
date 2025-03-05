package com.example.web.controller.admin.discountController;

import com.example.web.dao.model.Discount;
import com.example.web.service.DiscountService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Date;

@WebServlet("/admin/editDiscount")
public class EditDiscount extends HttpServlet {
    private DiscountService discountService = new DiscountService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Lấy thông tin từ form
        int discountId = Integer.parseInt(request.getParameter("discountId"));
        String discountName = request.getParameter("discountName");
        double discountPercentage = Double.parseDouble(request.getParameter("discountPercentage"));
        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");
        String imageUrl = request.getParameter("imageUrl");

        // Tạo đối tượng Discount và cập nhật thông tin
        Discount discount = new Discount();
        discount.setId(discountId);
        discount.setDiscountName(discountName);
        discount.setDiscountPercentage(BigDecimal.valueOf(discountPercentage));
        discount.setStartDate(Date.valueOf(startDate).toLocalDate());
        discount.setEndDate(Date.valueOf(endDate).toLocalDate());
        discount.setImageUrl(imageUrl);

        // Gọi service để cập nhật giảm giá trong cơ sở dữ liệu
        discountService.editDiscount(discount);



        // Chuyển hướng về trang danh sách giảm giá
        response.sendRedirect(request.getContextPath() + "/admin/discount");

    }
}

