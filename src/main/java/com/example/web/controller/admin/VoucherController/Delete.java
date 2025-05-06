package com.example.web.controller.admin.VoucherController;

import com.example.web.controller.util.CheckPermission;
import com.example.web.dao.model.User;
import com.example.web.service.ArtistService;
import com.example.web.service.VoucherService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.eclipse.tags.shaded.org.apache.regexp.RE;

import java.io.IOException;

@WebServlet("/admin/vouchers/delete")
public class Delete extends HttpServlet {
    private VoucherService voucherService = new VoucherService();

    private final String permission ="DELETE_VOUCHERS";
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        boolean hasPermission = CheckPermission.checkPermission(user, permission, "ADMIN");
        if (!hasPermission) {
            response.sendRedirect(request.getContextPath() + "/NoPermission.jsp");
            return;
        }

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
