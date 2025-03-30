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
import com.example.web.vnpay.Config;

import java.time.LocalDateTime;

public class CheckoutService {
    private final OrderDao orderDao;
    private final OrderItemDao orderItemDao;
    private final PaymentDao paymentDao;
    private final PaintingDao paintingDao;

    public CheckoutService(){
        orderDao = new OrderDao();
        orderItemDao = new OrderItemDao();
        paymentDao = new PaymentDao();
        paintingDao = new PaintingDao();

    }
    public int processCheckout(Cart cart, int userId, int paymentMethodId,
                               String recipientName, String recipientPhone,
                               String deliveryAddress) throws Exception {

        // Tạo đơn hàng mới
        Order order = new Order();
        order.setUserId(userId);
        order.setTotalAmount(cart.getFinalPrice());
        order.setStatus("chờ");
        order.setDeliveryAddress(deliveryAddress);
        order.setRecipientName(recipientName);
        order.setRecipientPhone(recipientPhone);
        order.setPaymentMethod(paymentMethodId == 1 ? "COD" : "VNPay");

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
        payment.setPaymentStatus("chờ");
        payment.setPaymentDate(LocalDateTime.now());

        if (paymentMethodId == 2) {
            String txnRef = Config.getRandomNumber(8); // Tạo mã giao dịch ngẫu nhiên
            payment.setTransactionId(txnRef);
        }

        paymentDao.createPayment(payment);

        return orderId;
    }

}
