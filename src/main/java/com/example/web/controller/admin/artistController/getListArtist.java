package com.example.web.controller.admin.artistController;

import com.example.web.controller.util.CheckPermission;
import com.example.web.dao.ArtistDao;
import com.example.web.dao.model.Artist;
import com.example.web.dao.model.User;
import com.example.web.service.ArtistService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/admin/artists")
public class getListArtist extends HttpServlet {
    private ArtistService artistService = new ArtistService();
    private final String permission = "VIEW_ARTISTS";

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("user");

        boolean hasPermission = CheckPermission.checkPermission(user, permission, "ADMIN");
        if (!hasPermission) {
            resp.sendRedirect(req.getContextPath() + "/NoPermission.jsp");
            return;
        }

        try {
            List<Artist> artits = artistService.getAllArtists();
            req.setAttribute("artists", artits);
            req.getRequestDispatcher("artists.jsp").forward(req, resp);
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }
}
