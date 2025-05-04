package com.example.web.controller.admin.artistController;

import com.example.web.controller.util.CheckPermission;
import com.example.web.dao.model.User;
import com.example.web.service.ArtistService;
import jakarta.servlet.ServletContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.File;
import java.io.IOException;

@WebServlet("/admin/artists/add")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2,
        maxFileSize = 1024 * 1024 * 10,
        maxRequestSize = 1024 * 1024 * 50
)
public class Add extends HttpServlet {
    private ArtistService artistService = new ArtistService();
  //  private static final String UPLOAD_DIR = "assets/images";
    private static final String UPLOAD_DIR = "N:/web//web//src//main//webapp//assets//images//artists";
    private final String permission ="ADD_ARTISTS";


    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User userC = (User) session.getAttribute("user");

        boolean hasPermission = CheckPermission.checkPermission(userC, permission, "ADMIN");
        if (!hasPermission) {
            response.sendRedirect(request.getContextPath() + "/NoPermission.jsp");
            return;
        }
        String name = request.getParameter("name");
        String bio = request.getParameter("bio");
        String birthDate = request.getParameter("birthDate");
        String nationality = request.getParameter("nationality");

        try {
            Part part = request.getPart("photo");
         //   System.out.println("part :"+part);
          //  System.out.println("partname :"+ part.getSubmittedFileName());
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

            String photoUrl = "assets/images/artists/" + img;

            boolean isAdded = artistService.addArtist(name, bio, birthDate, nationality, photoUrl);

            if (isAdded) {
                request.setAttribute("message", "Thêm họa sĩ thành công!");
            } else {
                request.setAttribute("message", "Thêm họa sĩ thất bại!");
            }
        } catch (Exception e) {
            request.setAttribute("message", "Lỗi: " + e.getMessage());
        }
        request.getRequestDispatcher("../artists.jsp").forward(request, response);
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
