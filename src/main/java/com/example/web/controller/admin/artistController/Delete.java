package com.example.web.controller.admin.artistController;

import com.example.web.controller.util.CheckPermission;
import com.example.web.dao.ArtistDao;
import com.example.web.dao.model.User;
import com.example.web.service.ArtistService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/admin/artists/delete")
public class Delete extends HttpServlet {
    private ArtistService artistService = new ArtistService();
    private final String permission ="DELETE_ARTISTS";
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        boolean hasPermission = CheckPermission.checkPermission(user, permission, "ADMIN");
        if (!hasPermission) {
            response.sendRedirect(request.getContextPath() + "/NoPermission.jsp");
            return;
        }

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
