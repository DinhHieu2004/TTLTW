package com.example.web.controller.admin.paintingController;

import com.example.web.dao.model.Painting;
import com.example.web.dao.model.User;
import com.example.web.service.PaintingService;
import com.google.gson.Gson;
import com.google.gson.JsonObject;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.*;

@WebServlet("/admin/paintings/add")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2,
        maxFileSize = 1024 * 1024 * 10,
        maxRequestSize = 1024 * 1024 * 50
)
public class Add extends HttpServlet {
    private static final String UPLOAD_DIR = "D://web/web/src/main/webapp/assets/images/artists";
    private final PaintingService paintingService = new PaintingService();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {


        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");

        JsonObject jsonResponse = new JsonObject();
        PrintWriter out = resp.getWriter();

        User user = (User) req.getSession().getAttribute("user");
        if (user == null || !user.hasPermission("ADD_PRODUCT")) {
            jsonResponse.addProperty("success", false);
            jsonResponse.addProperty("message", "Bạn không có quyền thêm sản phẩm!");
            out.print(new Gson().toJson(jsonResponse));
            out.flush();
            return;
        }


        String title = req.getParameter("title");
        String description = req.getParameter("description");
        int themeId = Integer.parseInt(req.getParameter("themeId"));
        int artistId = Integer.parseInt(req.getParameter("artistId"));
        String priceStr = req.getParameter("price");
        String isFeaturedStr = req.getParameter("isFeatured");

        Part part = req.getPart("image");
        String img = extractFileName(part);

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
            int paintingId = paintingService.addPainting(title, themeId, price, artistId, description, photoUrl, isFeatured);

            if (paintingId != -1) {
                paintingService.addPaintingSizes(paintingId, sizeList, quantityList);
                Painting newPainting = paintingService.getPainting(paintingId);
                JsonObject paintingJson = new JsonObject();
                paintingJson.addProperty("id", newPainting.getId());
                String urlImage = req.getContextPath() + "/assets/images/artists/" + img;
                paintingJson.addProperty("imageUrl", urlImage);
                paintingJson.addProperty("title", newPainting.getTitle());
                paintingJson.addProperty("available", newPainting.getAvailable());
                paintingJson.addProperty("price", newPainting.getPrice());
                paintingJson.addProperty("createDate", newPainting.getCreateDate().toString());
                paintingJson.addProperty("artistName", newPainting.getArtistName());

                jsonResponse.add("painting", paintingJson);
                jsonResponse.addProperty("success", true);
                jsonResponse.addProperty("message", "Thêm tranh thành công!");
            } else {
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "Thêm tranh thất bại!");
            }
        } catch (Exception e) {
            jsonResponse.addProperty("success", false);
            jsonResponse.addProperty("message", "Lỗi: " + e.getMessage());
        }
        // Gửi JSON response về client
        out.print(new Gson().toJson(jsonResponse));
        out.flush();

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
