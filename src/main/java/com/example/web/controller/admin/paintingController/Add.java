package com.example.web.controller.admin.paintingController;

import com.example.web.service.PaintingService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

@WebServlet("/admin/paintings/add")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2,
        maxFileSize = 1024 * 1024 * 10,
        maxRequestSize = 1024 * 1024 * 50
)
public class Add extends HttpServlet {
    private static final String UPLOAD_DIR = "N:/web//web//src//main//webapp//assets//images//artists";
    private PaintingService paintingService = new PaintingService();
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String title = req.getParameter("title");
        String description = req.getParameter("description");
        int themeId = Integer.parseInt(req.getParameter("themeId"));
        int artistId = Integer.parseInt(req.getParameter("artistId"));
        String priceStr = req.getParameter("price");
        String isFeaturedStr = req.getParameter("isFeatured");

        Part part = req.getPart("image");
        String img =  extractFileName(part);

        double price = Double.parseDouble(priceStr);
        boolean isFeatured = isFeaturedStr != null;

        String[] sizeIds = req.getParameterValues("sizeId[]");
        String[] quantities = req.getParameterValues("quantity[]");

        List<Integer> sizeList = new ArrayList<>();
        List<Integer> quantityList = new ArrayList<>();

        for (String q : quantities) {
            try {
                int number = Integer.parseInt(q);
                quantityList.add(number);
            } catch (NumberFormatException e) {
            }
        }
        for (String numberStr : sizeIds) {
            try {
                int number = Integer.parseInt(numberStr);
                sizeList.add(number);
            } catch (NumberFormatException e) {
            }
        }

        if (sizeIds != null && quantities != null) {
            for (int i = 0; i < sizeIds.length; i++) {
                int sizeId = Integer.parseInt(sizeIds[i]);
                int quantity = Integer.parseInt(quantities[i]);

                System.out.println("Size ID: " + sizeId + ", Quantity: " + quantity);

            }
        }

        if (img != null && !img.isEmpty()) {
            img = img.replaceAll(" ", "_");
        }


        File directory = new File(UPLOAD_DIR);
        if (!directory.exists()) {
            directory.mkdirs();
        }

        part.write(UPLOAD_DIR + File.separator + img);

        String photoUrl = "assets/images/artists/" + img;
        try {
        int paintingId = paintingService.addPainting(title,themeId,price,artistId,description,photoUrl,isFeatured);

        if (paintingId != -1) {
            paintingService.addPaintingSizes(paintingId, sizeList, quantityList);
            req.setAttribute("message", "Thêm sản phẩm thành công!");
        } else {
            req.setAttribute("message", "Thêm sản phẩm thất bại!");
        }
    } catch (Exception e) {
        req.setAttribute("message", "Lỗi: " + e.getMessage());
    }
        resp.sendRedirect("../products");

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
