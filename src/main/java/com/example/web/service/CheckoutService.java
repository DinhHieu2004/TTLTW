package com.example.web.service;

import com.example.web.controller.util.OrderCacheManager;
import com.example.web.dao.OrderDao;
import com.example.web.dao.OrderItemDao;
import com.example.web.dao.PaintingDao;
import com.example.web.dao.PaymentDao;
import com.example.web.dao.cart.Cart;
import com.example.web.dao.cart.CartPainting;
import com.example.web.dao.model.*;
import com.example.web.vnpay.Config;

import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class CheckoutService {
    private final OrderDao orderDao;
    private final OrderItemDao orderItemDao;    private final PaymentDao paymentDao;
    private final PaintingDao paintingDao;

    public CheckoutService() {
        orderDao = new OrderDao();
        orderItemDao = new OrderItemDao();
        paymentDao = new PaymentDao();
        paintingDao = new PaintingDao();

    }

    public void processCheckout(Cart cart, int userId, int paymentMethodId, String recipientName, String recipientPhone, String deliveryAddress, double shippingFee, String appliedVoucherIds, Double shippingFeeAfterVoucher) throws Exception {
        double originalPrice = cart.getTotalPrice();
        double discountPrice = cart.getFinalPrice();
        if(discountPrice == 0) {
            discountPrice = originalPrice;
        }
        double shippingFeeFinal = (shippingFeeAfterVoucher != null) ? shippingFeeAfterVoucher : shippingFee;
        double priceAfterShipping = discountPrice + shippingFeeFinal;

        Order order = new Order();
        order.setUserId(userId);
        order.setTotalAmount(originalPrice);
        order.setPriceAfterShipping(priceAfterShipping);
        order.setPaymentStatus("chưa thanh toán");
        order.setDeliveryStatus("chờ");
        order.setDeliveryAddress(deliveryAddress);
        order.setRecipientName(recipientName);
        order.setPaymentMethod("COD");
        order.setRecipientPhone(recipientPhone);
        order.setShippingFee(shippingFee);
        order.setAppliedVoucherIds(appliedVoucherIds);
        int orderId = orderDao.createOrder(order);

        for (CartPainting item : cart.getItems()) {
            OrderItem orderItem = new OrderItem();
            orderItem.setOrderId(orderId);
            orderItem.setPaintingId(item.getProductId());
            orderItem.setSizeId(item.getSizeId());
            orderItem.setPrice(item.getDiscountPrice());
            orderItem.setQuantity(item.getQuantity());
            orderItemDao.addOrderItem(orderItem);
            paintingDao.updateQuanity(item.getProductId(), item.getSizeId(), item.getQuantity());

        }
        Payment payment = new Payment();
        payment.setOrderId(orderId);
        payment.setUserId(userId);
        payment.setMethodId(paymentMethodId);
        payment.setPaymentStatus(paymentMethodId == 1 ? "đã thanh toán" : "chờ");
        payment.setPaymentDate(LocalDateTime.now());
        paymentDao.createPayment(payment);


    }

    public int processCheckout2(Cart cart, int userId, int paymentMethodId,
                                String recipientName, String recipientPhone,
                                String deliveryAddress, String vnpTxnRef, double shippingFee, String appliedVoucherIds, Double shippingFeeAfterVoucher) throws Exception {
        double originalPrice = cart.getTotalPrice();
        double discountPrice = cart.getFinalPrice();
        if(discountPrice == 0) {
            discountPrice = originalPrice;
        }
        double shippingFeeFinal = (shippingFeeAfterVoucher != null) ? shippingFeeAfterVoucher : shippingFee;
        double priceAfterShipping = discountPrice + shippingFeeFinal;

        // Tạo đơn hàng mới
        Order order = new Order();
        order.setUserId(userId);
        order.setTotalAmount(originalPrice);
        order.setPriceAfterShipping(priceAfterShipping);
        order.setPaymentStatus("đã thanh toán");
        order.setDeliveryStatus("chờ");
        order.setDeliveryAddress(deliveryAddress);
        order.setRecipientName(recipientName);
        order.setVnpTxnRef(vnpTxnRef);
        order.setPaymentMethod("VNPay");
        order.setRecipientPhone(recipientPhone);
        order.setAppliedVoucherIds(appliedVoucherIds);

        order.setShippingFee(shippingFee);

        int orderId = orderDao.createOrder2(order);

        for (CartPainting item : cart.getItems()) {
            OrderItem orderItem = new OrderItem();
            orderItem.setOrderId(orderId);
            orderItem.setPaintingId(item.getProductId());
            orderItem.setSizeId(item.getSizeId());
            orderItem.setPrice(item.getDiscountPrice());
            orderItem.setQuantity(item.getQuantity());
            orderItemDao.addOrderItem(orderItem);
            paintingDao.updateQuanity(item.getProductId(), item.getSizeId(), item.getQuantity());

        }
        Payment payment = new Payment();
        payment.setOrderId(orderId);
        payment.setUserId(userId);
        payment.setMethodId(paymentMethodId);
        payment.setPaymentStatus(paymentMethodId == 1 ? "đã thanh toán" : "chờ");
        payment.setPaymentDate(LocalDateTime.now());
        paymentDao.createPayment(payment);

        return orderId;
    }
    public List<Painting> getOutOfStockList(Cart cart) throws SQLException {
        List<CartPainting> paintingList = cart.getItems();
        List<Painting> outOfStockList = new ArrayList<>();
      //  List<Painting> inventoryList = new ArrayList<>();

        Painting painting =null;
        boolean result = false;
        for (CartPainting p : paintingList) {
            painting = paintingDao.getInventory(p);

            result = checkQuantity(p.getSizeId(), painting, p.getQuantity());

            if (!result) {
                outOfStockList.add(painting);
            }

        }
        return outOfStockList;
    }

    private boolean checkQuantity(int sizeId, Painting painting, int quantity) {

        for(PaintingSize ps : painting.getSizes()){

            if(sizeId == ps.getIdSize() && ps.getDisplayQuantity() >= quantity){
                return true;
            }
        }
        return false;
    }

    public static void main(String[] args) {

    }

}
