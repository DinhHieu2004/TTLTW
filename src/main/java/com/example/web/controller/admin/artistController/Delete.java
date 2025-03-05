package com.example.web.controller.admin.artistController;

import com.example.web.dao.ArtistDao;
import com.example.web.service.ArtistService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/admin/artists/delete")
public class Delete extends HttpServlet {
    private ArtistService artistService = new ArtistService();
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        String artistId = request.getParameter("artistId");
                try {
                    boolean isDeleted = artistService.deleteArtist(Integer.parseInt(artistId));
                    if (isDeleted) {
                        request.setAttribute("message", "Xóa họa sĩ thành công!");
                    } else {
                        request.setAttribute("message", "Xóa họa sĩ thất bại!");
                    }
                } catch (Exception e) {
                    request.setAttribute("message", "Lỗi: " + e.getMessage());
                }
        response.sendRedirect("../artists");
        //request.getRequestDispatcher("../artists.jsp").forward(request, response);
            }


}
