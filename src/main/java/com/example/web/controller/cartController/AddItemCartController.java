package com.example.web.controller.cartController;
import com.example.web.dao.cart.Cart;
import com.example.web.dao.cart.CartPainting;
import com.example.web.dao.model.Level;
import com.example.web.dao.model.Painting;
import com.example.web.dao.model.PaintingSize;
import com.example.web.dao.model.User;
import com.example.web.service.LogService;
import com.example.web.service.PaintingService;
import com.example.web.service.SizeService;
import com.google.gson.Gson;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet(name = "Add-to-cart", value = "/add-to-cart")
public class AddItemCartController extends HttpServlet {
    PaintingService paintingService = new PaintingService();
    SizeService sizeService = new SizeService();
    LogService logService = new LogService();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            int id = Integer.parseInt(req.getParameter("pid"));

            Painting p = paintingService.getPaintingDetail(id);
            System.out.println(p.getImageUrlCloud());

            String size = req.getParameter("size");
            int quantityOfSize = Integer.parseInt(req.getParameter("quantity_" + size));

            int quantity = Integer.parseInt(req.getParameter("quantity"));

            PaintingSize paintingSize = sizeService.getSizeById(Integer.parseInt(size));
            String sizeDescriptions = paintingSize.getSizeDescriptions();
            double weight = paintingSize.getWeight();

            CartPainting cartPainting = new CartPainting(
                    p.getId(),
                    p.getTitle(),
                    size,
                    sizeDescriptions,
                    weight,
                    quantity,
                    p.getPrice(),
                    p.getImageUrl(),
                    p.getImageUrlCloud(),
                    quantityOfSize,
                    p.getDiscountPercentage()
            );
            System.out.println(cartPainting);

            HttpSession session = req.getSession();
            Cart cart = (Cart) session.getAttribute("cart");
            if (cart == null) {
                cart = new Cart();
            }
            cart.addToCart(cartPainting);
            cart.getTotalPrice();
            session.setAttribute("cart", cart);

            System.out.println("cart : "+cart);


            User user = (User) req.getSession().getAttribute("user");
 //           String fullAddress = req.getSession().getAttribute("fullAddress").toString();

//            if (user != null) {
//               logService.addLog(String.valueOf(Level.INFO), req, null, null);
//            } else {
//                logService.addLog(String.valueOf(Level.INFO), req,  null, null);
//            }

            String requestedWith = req.getHeader("X-Requested-With");
            if ("XMLHttpRequest".equals(requestedWith)) {
                resp.setContentType("application/json");
                resp.setCharacterEncoding("UTF-8");
                String jsonResponse = new Gson().toJson(cart);
                resp.getWriter().write("{\"status\": \"success\", \"message\": \"Thêm vào giỏ hàng thành công!\", \"cart\": " + jsonResponse + "}");
            } else {
                resp.sendRedirect("painting-detail?pid=" + id);
            }

        } catch (SQLException e) {
            resp.setContentType("application/json");
            resp.setCharacterEncoding("UTF-8");
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            resp.getWriter().write("{\"status\": \"error\", \"message\": \"Đã xảy ra lỗi khi thêm vào giỏ hàng!\"}");
            e.printStackTrace();
        }
    }


}
