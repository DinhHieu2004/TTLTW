package com.example.web.controller.admin.paintingController;

import com.example.web.controller.util.CheckPermission;
import com.example.web.dao.model.Painting;
import com.example.web.dao.model.User;
import com.example.web.service.PaintingService;
import com.google.gson.Gson;
import com.google.gson.JsonObject;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/admin/paintings/update")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2,
        maxFileSize = 1024 * 1024 * 10,
        maxRequestSize = 1024 * 1024 * 50
)
public class Update extends HttpServlet {
    private static final String UPLOAD_DIR = "D://web/web/src/main/webapp/assets/images/artists";

    private final PaintingService paintingService = new PaintingService();
    private final String permission ="UPDATE_PRODUCTS";


    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("user");

        boolean hasPermission = CheckPermission.checkPermission(user, permission, "ADMIN");

        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");

        JsonObject jsonResponse = new JsonObject();
        PrintWriter out = resp.getWriter();

     //   User user = (User) req.getSession().getAttribute("user");
        if (user == null || hasPermission) {
            jsonResponse.addProperty("success", false);
            jsonResponse.addProperty("message", "Bạn không có quyền chỉnh sửa sản phẩm!");
            out.print(new Gson().toJson(jsonResponse));
            out.flush();
            return;
        }


        int id = Integer.parseInt(req.getParameter("pid"));
        String title = req.getParameter("title");
        String description = req.getParameter("description");
        int themeId = Integer.parseInt(req.getParameter("themeId"));
        int artistId = Integer.parseInt(req.getParameter("artistId"));
        String priceStr = req.getParameter("price");
        String isFeaturedStr = req.getParameter("isFeatured");
        String isSoldStr = req.getParameter("isSold");
        System.out.println(isSoldStr);

        Part part = req.getPart("image");
        String img = extractFileName(part);

        double price = Double.parseDouble(priceStr);
        boolean isFeatured = isFeaturedStr != null && isFeaturedStr.equals("on");
        System.out.println("f: " + isFeatured);

        boolean isSold = isSoldStr == null || !isSoldStr.equals("true");
        System.out.println("isSold: " + !isSold);

        List<Integer> sizeList = parseIntegerList(req.getParameterValues("sizeId[]"));
        List<Integer> quantityList = parseIntegerList(req.getParameterValues("quantity[]"));

        if (img != null && !img.isEmpty()) {
            img = img.replaceAll(" ", "_");
        }

        File directory = new File(UPLOAD_DIR);
        if (!directory.exists()) {
            directory.mkdirs();
        }

        if (part != null && img != null && !img.isEmpty()) {
            part.write(UPLOAD_DIR + File.separator + img);
        }

        String photoUrl = null;
        try {
            photoUrl = img != null && !img.isEmpty() ? "assets/images/artists/" + img : paintingService.getCurrentImagePath(id);
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }

        try {
            boolean updated = paintingService.updatePainting(id, title, themeId, price, artistId, description, photoUrl,!isSold, isFeatured);

            if (updated) {
                paintingService.updatePaintingSizes(id, sizeList, quantityList);

                jsonResponse.addProperty("success", true);
                jsonResponse.addProperty("message", "Cập nhật tranh thành công!");

                // Trả về dữ liệu mới
                Painting updatedPainting = paintingService.getPainting(id);
                JsonObject paintingJson = new JsonObject();
                paintingJson.addProperty("id", updatedPainting.getId());

                String imageUrl = req.getContextPath() + "/" +updatedPainting.getImageUrl();

                paintingJson.addProperty("imageUrl", imageUrl);
                paintingJson.addProperty("title", updatedPainting.getTitle());
                paintingJson.addProperty("available", updatedPainting.getAvailable());
                paintingJson.addProperty("price", updatedPainting.getPrice());
                paintingJson.addProperty("createDate", updatedPainting.getCreateDate().toString());
                paintingJson.addProperty("artistName", updatedPainting.getArtistName());

                jsonResponse.add("painting", paintingJson);
            } else {
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "Cập nhật tranh thất bại!");
            }
        } catch (Exception e) {
            jsonResponse.addProperty("success", false);
            jsonResponse.addProperty("message", "Lỗi: " + e.getMessage());
        }
        out.print(jsonResponse.toString());
        out.flush();
    }

    private String extractFileName(Part part) {
        if(part == null) {
            return null;
        }
        String contentDisposition = part.getHeader("content-disposition");
        String[] elements = contentDisposition.split(";");
        for (String element : elements) {
            if (element.trim().startsWith("filename")) {
                return element.substring(element.indexOf("=") + 2, element.length() - 1);
            }
        }
        return null;
    }

    private List<Integer> parseIntegerList(String[] values) {
        List<Integer> list = new ArrayList<>();
        if (values != null) {
            for (String value : values) {
                try {
                    int number = Integer.parseInt(value);
                    list.add(number);
                } catch (NumberFormatException e) {
                }
            }
        }
        return list;
    }
}
