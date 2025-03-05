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

@WebServlet("/admin/removePaintingFromDiscount")
public class RemoveProductFromDiscount extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Thiết lập kiểu dữ liệu phản hồi là JSON
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        // Lấy productId và discountId từ request
        String productIdParam = request.getParameter("productId");
        String discountIdParam = request.getParameter("discountId");

        // Kiểm tra tính hợp lệ của tham số
        if (productIdParam == null || productIdParam.isEmpty() || discountIdParam == null || discountIdParam.isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"message\": \"Mã sản phẩm hoặc chương trình giảm giá không hợp lệ.\"}");
            return;
        }

        try {
            // Chuyển đổi productId và discountId từ String sang int
            int productId = Integer.parseInt(productIdParam);
            int discountId = Integer.parseInt(discountIdParam);

            // Gọi phương thức removeProductFromDiscount từ DiscountService
            DiscountService service = new DiscountService();
            boolean isRemoved = service.removeProductFromDiscount(productId);

            if (isRemoved) {
                // Trả về phản hồi thành công
                response.setStatus(HttpServletResponse.SC_OK);
                response.getWriter().write("{\"message\": \"Xóa sản phẩm thành công.\"}");
            } else {
                // Trả về phản hồi nếu không tìm thấy sản phẩm
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                response.getWriter().write("{\"message\": \"Không tìm thấy sản phẩm trong chương trình giảm giá.\"}");
            }

        } catch (NumberFormatException e) {
            // Xử lý lỗi nếu không thể chuyển đổi sang số
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"message\": \"Mã sản phẩm hoặc chương trình giảm giá không hợp lệ.\"}");
        } catch (SQLException e) {
            // Xử lý lỗi khi gọi database
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"message\": \"Lỗi khi xử lý dữ liệu trên cơ sở dữ liệu.\"}");
        } catch (Exception e) {
            // Xử lý lỗi chung
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"message\": \"Đã xảy ra lỗi không xác định.\"}");
        }
    }
}
