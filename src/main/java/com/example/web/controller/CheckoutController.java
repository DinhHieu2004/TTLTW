package com.example.web.controller;

import com.example.web.controller.util.EmailConfirmService;
import com.example.web.dao.cart.Cart;
import com.example.web.dao.cart.CartPainting;
import com.example.web.dao.model.*;
import com.example.web.service.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.eclipse.tags.shaded.org.apache.xpath.operations.Or;

import java.io.IOException;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

@WebServlet(value = "/checkout")
public class CheckoutController extends HttpServlet {
    private final CheckoutService checkoutService = new CheckoutService();
    private final VoucherService voucherService = new VoucherService();
    private final UserVoucherService userVoucherService = new UserVoucherService();
    private final OrderService orderService = new OrderService();
    private final OrderItemService orderItemService = new OrderItemService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("user");
        int userId = user.getId();

        List<UserVoucher> userVouchers = null;
        try {
            userVouchers = userVoucherService.getAllByUserId(userId);
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        List<Voucher> validVouchers = new ArrayList<>();

        Timestamp now = new Timestamp(System.currentTimeMillis());

        for (UserVoucher uv : userVouchers) {
            Voucher v = uv.getVoucher();
            if(!uv.getIsUsed() && v.getStartDate().before(now) && v.getEndDate().after(now)) {
                validVouchers.add(v);
            }
        }
        req.setAttribute("v", validVouchers);
        req.getRequestDispatcher("user/checkout.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            HttpSession session = request.getSession();
            User user = (User) session.getAttribute("user");
            if(user == null){
                response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                response.getWriter().println("Bạn cần đăng nhập để tiếp tục thanh toán!");
                return;
            }
            int userId = user.getId();
            Cart cart = (Cart) request.getSession().getAttribute("cart");
            if (cart == null || cart.getItems().isEmpty()) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("Giỏ hàng của bạn đang trống!");
                return;
            }
            String recipientName = request.getParameter("recipientName");
            String deliveryAddress = request.getParameter("deliveryAddress");
            String recipientPhone = request.getParameter("recipientPhone");
            String paymentMethod = request.getParameter("paymentMethod");
            String shippingFee = request.getParameter("shippingFee");
            shippingFee = shippingFee.replace(".", "");
            String[] voucherIds  = request.getParameterValues("voucherCodes");
            double shippingFeeDouble = Double.parseDouble(shippingFee);
            double shippingFeeFinal = session.getAttribute("shippingFeeAfterVoucher") != null
                    ? (Double) session.getAttribute("shippingFeeAfterVoucher")
                    : shippingFeeDouble;

            String appliedVoucherIds = (voucherIds != null) ? String.join(",", voucherIds) : null;

            int paymentMethodInt = Integer.parseInt(paymentMethod);


            try {
                List<Painting> inventoryPainting = checkoutService.getOutOfStockList(cart);

                if (inventoryPainting != null && !inventoryPainting.isEmpty()) {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);

                    StringBuilder outOfStockNames = new StringBuilder("Các sản phẩm sau đã hết hàng hoặc không đủ số lượng:\n");

                    for (CartPainting cp : cart.getItems()) {
                        for (Painting p : inventoryPainting) {
                            if (cp.getProductId() == p.getId()) {
                                String sizeName = "";
                                for (PaintingSize ps : p.getSizes()) {
                                    if (ps.getIdSize() == cp.getSizeId()) {
                                        sizeName = ps.getSizeDescriptions();
                                        break;
                                    }
                                }
                                outOfStockNames.append("- ").append(p.getTitle())
                                        .append(" (Kích thước: ").append(sizeName).append(")").append("\n");
                            }
                        }
                    }

                    response.setContentType("text/plain;charset=UTF-8");
                    response.getWriter().write(outOfStockNames.toString());
                    return;
                }
                checkoutService.processCheckout(cart, userId,paymentMethodInt,recipientName, recipientPhone, deliveryAddress, shippingFeeDouble, appliedVoucherIds, shippingFeeFinal);
                // Gửi email xác nhận đơn hàng (COD)
                Order order = orderService.getLastOrderOfUser(userId);
                List<OrderItem> orderItems = orderItemService.getOrderItems(order.getId());
                String appliedVoucherCodes;

                if (voucherIds != null && voucherIds.length > 0) {
                    List<String> codes = new ArrayList<>();
                    for (String vid : voucherIds) {
                        int id = Integer.parseInt(vid);
                        String code = voucherService.getVoucherCodeById(id);
                        if (code != null) codes.add(code);
                    }
                    appliedVoucherCodes = String.join(", ", codes);
                } else {
                    appliedVoucherCodes = "";
                }

                new Thread(() -> {
                    try {
                        EmailConfirmService.sendOrderConfirmation(user.getEmail(), order, orderItems, appliedVoucherCodes);
                    } catch (Exception ex) {
                        ex.printStackTrace();
                    }
                }).start();

                session.removeAttribute("cart");
                response.setStatus(HttpServletResponse.SC_OK);
                response.getWriter().write("Đặt hàng thành công!");
            } catch (Exception e) {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                response.getWriter().write("Có lỗi xảy ra trong quá trình đặt hàng. Vui lòng thử lại!");
                e.printStackTrace();
            }
        } catch (Exception e) {
            response.setContentType("application/json");
            response.getWriter().write("{\"success\": false, \"message\": \"Có lỗi xảy ra: " + e.getMessage() + "\"}");
        }
    }
}