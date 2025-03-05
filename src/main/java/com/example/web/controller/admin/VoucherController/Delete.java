package com.example.web.controller.admin.VoucherController;

import com.example.web.service.ArtistService;
import com.example.web.service.VoucherService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/admin/vouchers/delete")
public class Delete extends HttpServlet {
    private VoucherService voucherService = new VoucherService();
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        String vid = request.getParameter("vid");
        try {
            boolean isDeleted = voucherService.deleteVoucher(vid);
            if (isDeleted) {
                request.setAttribute("message", "Xóa voucher thành công!");
            } else {
                request.setAttribute("message", "Xóa voucher thất bại!");
            }
        } catch (Exception e) {
            request.setAttribute("message", "Lỗi: " + e.getMessage());
        }
        response.sendRedirect("../vouchers");
        //request.getRequestDispatcher("../artists.jsp").forward(request, response);
    }


}
