/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package com.example.web.vnpay;

import com.example.web.controller.util.EmailConfirmService;
import com.example.web.dao.cart.Cart;
import com.example.web.dao.cart.CartPainting;
import com.example.web.dao.model.*;
import com.example.web.service.*;

import java.io.IOException;
import java.io.PrintWriter;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.*;

@WebServlet("/vnpay_return")
public class VnpayReturn extends HttpServlet {
    private final OrderService orderService = new OrderService();
    private final OrderItemService orderItemService = new OrderItemService();
    private final UserService userService = new UserService();
    private final CheckoutService checkoutService = new CheckoutService();
    private final UserVoucherService userVoucherService = new UserVoucherService();
    private final VoucherService voucherService = new VoucherService();

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();

        User userNow = (User) session.getAttribute("user");
        int userId = userNow.getId();
        Cart cart = (Cart) session.getAttribute("cart");
        String recipientName = (String) session.getAttribute("recipientName");
        String deliveryAddress = (String) session.getAttribute("deliveryAddress");
        String recipientPhone = (String) session.getAttribute("recipientPhone");
        String shippingFeeStr = (String) session.getAttribute("shippingFee");
        String[] voucherIds = (String[]) session.getAttribute("voucherIds");
        String appliedVoucherIds = (voucherIds != null) ? String.join(",", voucherIds) : null;
        shippingFeeStr = shippingFeeStr.replace(".", "");
        double shippingFee = Double.parseDouble(shippingFeeStr);
        double shippingFeeFinal = session.getAttribute("shippingFeeAfterVoucher") != null
                ? (Double) session.getAttribute("shippingFeeAfterVoucher")
                : shippingFee;

        response.setContentType("text/html;charset=UTF-8");

        try ( PrintWriter out = response.getWriter()) {
            Map fields = new HashMap();
            for (Enumeration params = request.getParameterNames(); params.hasMoreElements();) {
                String fieldName = URLEncoder.encode((String) params.nextElement(), StandardCharsets.US_ASCII.toString());
                String fieldValue = URLEncoder.encode(request.getParameter(fieldName), StandardCharsets.US_ASCII.toString());
                if ((fieldValue != null) && (fieldValue.length() > 0)) {
                    fields.put(fieldName, fieldValue);
                }
            }

            String vnp_SecureHash = request.getParameter("vnp_SecureHash");
            if (fields.containsKey("vnp_SecureHashType")) {
                fields.remove("vnp_SecureHashType");
            }
            if (fields.containsKey("vnp_SecureHash")) {
                fields.remove("vnp_SecureHash");
            }
            String signValue = Config.hashAllFields(fields);
            if (signValue.equals(vnp_SecureHash)) {
                String paymentCode = request.getParameter("vnp_TransactionNo");

                String vnpTxnRef = (String) session.getAttribute("vnp_TxnRef");
//
//               int orderIdInt = Integer.parseInt(orderId);

                boolean transSuccess = false;

                String transactionStatus = request.getParameter("vnp_TransactionStatus");
                String responseCode = request.getParameter("vnp_ResponseCode");

                int orderId = 0;
                Order order = null;
                List<OrderItem> orderItems = null;
                User user = null;
                if ("00".equals(transactionStatus)) {
                    //update order status
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

                        orderId = checkoutService.processCheckout2(cart, userId, 2, recipientName, recipientPhone, deliveryAddress, vnpTxnRef, shippingFee, appliedVoucherIds, shippingFeeFinal);
                        orderService.updatePaymentStatus(orderId, "đã thanh toán");
                        if (voucherIds != null) {
                            for (String vidStr : voucherIds) {
                                int voucherId = Integer.parseInt(vidStr);
                                userVoucherService.markAsUsed(voucherId, userId);
                            }
                        }


                        // Lấy thông tin từ db
                        order = orderService.getOrder(orderId);
                        orderItems = orderItemService.getOrderItems(orderId);
                        // Lấy email nhận đơn hàng

                        user = userService.getUser(order.getUserId());

                        request.setAttribute("userEmail", user.getEmail());

                        // Lưu thông tin vào để chuyển đến trang thanh toán thành công
                        if(orderItems != null) {
                            request.setAttribute("order", order);
                            request.setAttribute("orderItems", orderItems);
                        }
                        transSuccess = true;
                        session.removeAttribute("cart");

                    } catch (Exception e) {
                        throw new RuntimeException(e);
                    }

                }

                if (transSuccess) {
                    String appliedVoucherCodes;

                    if (voucherIds != null && voucherIds.length > 0) {
                        List<String> codes = new ArrayList<>();
                        for (String vid : voucherIds) {
                            int id = Integer.parseInt(vid);
                            String code = voucherService.getVoucherCodeById(id);
                            if (code != null) codes.add(code);
                        }
                        appliedVoucherCodes = String.join(", ", codes);
                        request.setAttribute("appliedVoucherCodes", appliedVoucherCodes);
                    } else {
                        appliedVoucherCodes = "";
                    }
                    // gửi email xác nhận đơn
                    Order finalOrder = order;
                    List<OrderItem> finalOrderItems = orderItems;
                    User finalUser = user;
                    new Thread(() -> {
                        try {
                            EmailConfirmService.sendOrderConfirmation(finalUser.getEmail(), finalOrder, finalOrderItems, appliedVoucherCodes);
                        } catch (Exception ex) {
                            ex.printStackTrace();
                        }
                    }).start();

                    request.setAttribute("voucherGift", true);
                    request.getRequestDispatcher("user/payment_success.jsp").forward(request, response);
                } else {
                    request.setAttribute("transResult", transSuccess);
                    request.getRequestDispatcher("user/payment_cancelled.jsp").forward(request, response);
                }
            } else {
                // Trường hợp chữ ký không hợp lệ (giao dịch không hợp lệ)
                request.getRequestDispatcher("user/payment_failed.jsp").forward(request, response);
            }
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /** 
     * Handles the HTTP <code>GET</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        processRequest(request, response);
    } 

    /** 
     * Handles the HTTP <code>POST</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        processRequest(request, response);
    }

    /** 
     * Returns a short description of the servlet.
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
