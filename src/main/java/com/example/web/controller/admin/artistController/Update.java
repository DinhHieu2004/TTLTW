package com.example.web.controller.admin.artistController;

import com.example.web.dao.model.Artist;
import com.example.web.service.ArtistService;
import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import java.io.File;
import java.io.IOException;

import java.sql.SQLException;

@WebServlet("/admin/artists/update")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2,
        maxFileSize = 1024 * 1024 * 10,
        maxRequestSize = 1024 * 1024 * 50
)
public class Update extends HttpServlet {
    private static final String UPLOAD_DIR = "N:/web//web//src//main//webapp//assets//images//artists";
    private ArtistService artistService = new ArtistService();


    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("utf-8");

        int artistId = Integer.parseInt(req.getParameter("id"));
        String name = req.getParameter("name");
        String bio = req.getParameter("bio");
        String birthDate = req.getParameter("birthDate");
        String nationality = req.getParameter("nationality");

        System.out.println("id:"+artistId);
        System.out.println("bd:"+birthDate);

        Part photoPart = req.getPart("photo");
        String fileName = extractFileName(photoPart);

        if (fileName != null && !fileName.isEmpty()) {
            fileName = fileName.replaceAll(" ", "_");
        }

        File directory = new File(UPLOAD_DIR);
        if (!directory.exists()) {
            directory.mkdirs();
        }

        if (photoPart != null && fileName != null && !fileName.isEmpty()) {
            photoPart.write(UPLOAD_DIR + File.separator + fileName);
        }

        String photoUrl = null;
        try {
            photoUrl = fileName != null && !fileName.isEmpty() ? "assets/images/artists/" + fileName : artistService.getCurrentImagePath(artistId);
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }

        File file = new File(UPLOAD_DIR, fileName);
        photoPart.write(file.getAbsolutePath());
        Artist artist = new Artist();
        artist.setId(artistId);
        artist.setName(name);
        artist.setBio(bio);
        artist.setNationality(nationality);
        artist.setPhotoUrl(photoUrl);

        try {
            boolean isUpdated = artistService.updateArtist(artist, birthDate);
            if (isUpdated) {
                resp.sendRedirect("../artists");
            } else {
                resp.getWriter().write("{\"success\": false, \"message\": \"Cập nhật thất bại.\"}");
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
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