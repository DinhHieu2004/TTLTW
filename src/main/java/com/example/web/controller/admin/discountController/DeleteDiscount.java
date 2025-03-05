package com.example.web.controller.admin.discountController;

import com.example.web.service.DiscountService;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/admin/deleteDiscount")
public class DeleteDiscount extends HttpServlet {

    private DiscountService discountService = new DiscountService(); // Khởi tạo Service

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Lấy discountId từ yêu cầu POST
        String discountIdStr = request.getParameter("discountId");
        int discountId = 0;

        try {
            discountId = Integer.parseInt(discountIdStr);
        } catch (NumberFormatException e) {
            // Thêm thông báo lỗi nếu không thể chuyển discountId thành số
            request.setAttribute("errorMessage", "Mã giảm giá không hợp lệ.");
            request.getRequestDispatcher("/admin/discount").forward(request, response);
            return;
        }

        // Thử xóa chương trình giảm giá
        try {
            // Gọi service xóa chương trình giảm giá
            discountService.deleteDiscount(discountId);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Có lỗi xảy ra khi xóa chương trình giảm giá.");
        }

        // Sau khi xóa thành công, chuyển hướng về trang danh sách
        response.sendRedirect(request.getContextPath() + "/admin/discount");
    }
}



