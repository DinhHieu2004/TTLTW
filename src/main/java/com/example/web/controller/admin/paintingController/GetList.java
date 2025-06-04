package com.example.web.controller.admin.paintingController;

import com.example.web.controller.util.CheckPermission;
import com.example.web.dao.model.*;
import com.example.web.service.ArtistService;
import com.example.web.service.PaintingService;
import com.example.web.service.SizeService;
import com.example.web.service.ThemeService;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/admin/products")
public class GetList extends HttpServlet {
    private PaintingService paintingService = new PaintingService();
    private SizeService sizeService = new SizeService();
    private ThemeService themeService = new ThemeService();
    private ArtistService artistService = new ArtistService();
    private final String  permission = "VIEW_PRODUCTS";
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {


        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("user");

        boolean hasPermission = CheckPermission.checkPermission(user, permission, "ADMIN");
        if (!hasPermission) {
            resp.sendRedirect(req.getContextPath() + "/NoPermission.jsp");
            return;
        }



        List<Painting> listP  ;
        List<PaintingSize> listS  ;
        List<Theme> listP2  ;
        List<Artist> a ;
        //
        List<Painting> listPDelete  ;

        try {
            a = artistService.getAllArtists();
            listS = sizeService.getAllSize();
            listP2 = themeService.getAllTheme();
            listP = paintingService.getAll();

            //
            listPDelete = paintingService.getAllListDelete();
            req.setAttribute("products", listP);
            req.setAttribute("productsD", listPDelete);

            req.setAttribute("s", listS);
            req.setAttribute("t", listP2);
            req.setAttribute("a", a);


         //   System.out.println(listP);
            RequestDispatcher dispatcher = req.getRequestDispatcher("products.jsp");
            dispatcher.forward(req, resp);
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }


    }
}
