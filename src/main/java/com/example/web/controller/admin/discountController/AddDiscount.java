package com.example.web.controller.admin.discountController;

import com.example.web.dao.model.Discount;
import com.example.web.service.DiscountService;
import jakarta.servlet.ServletContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import java.io.File;
import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDate;


@WebServlet("/admin/discounts/add")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2,
        maxFileSize = 1024 * 1024 * 10,
        maxRequestSize = 1024 * 1024 * 50
)
public class AddDiscount extends HttpServlet {
    private static final String UPLOAD_DIR = "N:/web//web//src//main//webapp//assets//images//artists";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String discountName = request.getParameter("discountName");
        double discountPercentage = Double.parseDouble(request.getParameter("discountPercentage"));
        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");

        try {
            Part part = request.getPart("imageUrl");

            String img = extractFileName(part);
            System.out.println("img :"+ part.getSubmittedFileName());
            if (img != null && !img.isEmpty()) {
                img = img.replaceAll(" ", "_");
            }

            File directory = new File(UPLOAD_DIR);
            if (!directory.exists()) {
                directory.mkdirs();
            }

            part.write(UPLOAD_DIR + File.separator + img);
            String imageUrl = "assets/images/discounts/" + img;

            LocalDate start = LocalDate.parse(startDate);
            LocalDate end = LocalDate.parse(endDate);

            Discount discount = new Discount();
            discount.setDiscountName(discountName);
            discount.setDiscountPercentage(BigDecimal.valueOf(discountPercentage));
            discount.setStartDate(start);
            discount.setEndDate(end);
            discount.setImageUrl(imageUrl);

            DiscountService service = new DiscountService();
            boolean isAdded = service.addDiscount(discount);

            if (isAdded) {
                response.sendRedirect(request.getContextPath() + "/admin/discount");
            } else {
                request.setAttribute("errorMessage", "Có lỗi xảy ra khi thêm chương trình giảm giá!");
                request.getRequestDispatcher("/admin/discount").forward(request, response);
            }
        } catch (Exception e) {
            request.setAttribute("errorMessage", "Lỗi: " + e.getMessage());
            request.getRequestDispatcher("/admin/discount").forward(request, response);
        }
    }

    private String extractFileName(Part part) {
        String contentDisposition = part.getHeader("content-disposition");
        String[] elements = contentDisposition.split(";");
        for (String element : elements) {
            if (element.trim().startsWith("filename")) {
                return element.substring(element.indexOf("=") + 2, element.length() - 1);
            }
        }
        return null;
    }

}
