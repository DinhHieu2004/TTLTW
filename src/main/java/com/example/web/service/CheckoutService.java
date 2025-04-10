package com.example.web.service;

import com.example.web.dao.OrderDao;
import com.example.web.dao.OrderItemDao;
import com.example.web.dao.PaintingDao;
import com.example.web.dao.PaymentDao;
import com.example.web.dao.cart.Cart;
import com.example.web.dao.cart.CartPainting;
import com.example.web.dao.model.Order;
import com.example.web.dao.model.OrderItem;
import com.example.web.dao.model.Painting;
import com.example.web.dao.model.Payment;
import com.example.web.vnpay.Config;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class CheckoutService {
    private final OrderDao orderDao;
    private final OrderItemDao orderItemDao;
    private final PaymentDao paymentDao;
    private final PaintingDao paintingDao;

    public CheckoutService() {
        orderDao = new OrderDao();
        orderItemDao = new OrderItemDao();
        paymentDao = new PaymentDao();
        paintingDao = new PaintingDao();

    }

    public void processCheckout(Cart cart, int userId, int paymentMethodId, String recipientName, String recipientPhone, String deliveryAddress, double shippingFee) throws Exception {

        Order order = new Order();
        order.setUserId(userId);
        order.setTotalAmount(cart.getFinalPrice());
        order.setPriceAfterShipping(shippingFee + cart.getFinalPrice());
        order.setPaymentStatus("chưa thanh toán");
        order.setDeliveryStatus("chờ");
        order.setDeliveryAddress(deliveryAddress);
        order.setRecipientName(recipientName);
        order.setPaymentMethod("COD");
        order.setRecipientPhone(recipientPhone);
        order.setShippingFee(shippingFee);
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
                                String deliveryAddress, String vnpTxnRef, double shippingFee) throws Exception {


        // Tạo đơn hàng mới
        Order order = new Order();
        order.setUserId(userId);
        order.setTotalAmount(cart.getFinalPrice());
        order.setPriceAfterShipping(shippingFee + cart.getFinalPrice());
        order.setPaymentStatus("đã thanh toán");
        order.setDeliveryStatus("chờ");
        order.setDeliveryAddress(deliveryAddress);
        order.setRecipientName(recipientName);
        order.setVnpTxnRef(vnpTxnRef);
        order.setPaymentMethod("VNPay");
        order.setRecipientPhone(recipientPhone);

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
    private List<Painting> getOutOfStockList(Cart cart){
        List<CartPainting> paintingList = cart.getItems();
        List<Painting> outOfStockList = new ArrayList<>();
return null;

    }

}
