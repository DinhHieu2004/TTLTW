package com.example.web.service;

import com.example.web.dao.OrderDao;
import com.example.web.dao.OrderItemDao;
import com.example.web.dao.PaintingDao;
import com.example.web.dao.PaymentDao;
import com.example.web.dao.cart.Cart;
import com.example.web.dao.cart.CartPainting;
import com.example.web.dao.model.Order;
import com.example.web.dao.model.OrderItem;
import com.example.web.dao.model.Payment;
import java.time.LocalDateTime;

public class CheckoutService {
    private OrderDao orderDao;
    private OrderItemDao orderItemDao;
    private PaymentDao paymentDao;
    private PaintingDao paintingDao;

    public CheckoutService(){
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
        order.setStatus("chờ");
        order.setDeliveryAddress(deliveryAddress);
        order.setRecipientName(recipientName);
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
            paintingDao.updateQuanity(item.getProductId(), item.getSizeId(),item.getQuantity());

        }
        Payment payment = new Payment();
        payment.setOrderId(orderId);
        payment.setUserId(userId);
        payment.setMethodId(paymentMethodId);
        payment.setPaymentStatus(paymentMethodId == 1 ? "đã thanh toán" : "chờ");
        payment.setPaymentDate(LocalDateTime.now());
        paymentDao.createPayment(payment);
    }



}
