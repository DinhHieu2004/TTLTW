package com.example.web.controller.cartController;
import com.example.web.dao.cart.Cart;
import com.example.web.dao.cart.CartPainting;
import com.example.web.dao.model.Painting;
import com.example.web.dao.model.PaintingSize;
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

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            int id = Integer.parseInt(req.getParameter("pid"));

            Painting p = paintingService.getPaintingDetail(id);

            String size = req.getParameter("size");
            int quantityOfSize = Integer.parseInt(req.getParameter("quantity_" + size));

            System.out.println(size);
            int quantity = Integer.parseInt(req.getParameter("quantity"));
            System.out.println("so luong" + quantityOfSize);

            PaintingSize paintingSize = sizeService.getSizeById(Integer.parseInt(size));
            String sizeDescriptions = paintingSize.getSizeDescriptions();

            CartPainting cartPainting = new CartPainting(
                    p.getId(),
                    p.getTitle(),
                    size,
                    sizeDescriptions,
                    quantity,
                    p.getPrice(),
                    p.getImageUrl(),
                    quantityOfSize,
                    p.getDiscountPercentage()
            );

            HttpSession session = req.getSession();
            Cart cart = (Cart) session.getAttribute("cart");
            if (cart == null) {
                cart = new Cart();
            }
            cart.addToCart(cartPainting);
            session.setAttribute("cart", cart);

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
