package com.example.web.controller.util;

import com.example.web.dao.model.Order;
import com.example.web.dao.model.OrderItem;

import javax.mail.*;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import java.util.List;
import java.util.Properties;

public class EmailConfirmService {

    public static void sendOrderConfirmation(String recipientEmail, Order order, List<OrderItem> orderItems, String appliedVoucherCodes) {
        try {
            final String senderEmail = "t75339223@gmail.com";
            final String appPassword = "vqru uohb qgdf hifa";

            Properties props = new Properties();
            props.put("mail.smtp.host", "smtp.gmail.com");
            props.put("mail.smtp.port", "587");
            props.put("mail.smtp.auth", "true");
            props.put("mail.smtp.starttls.enable", "true");

            Session session = Session.getInstance(props, new Authenticator() {
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication(senderEmail, appPassword);
                }
            });

            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(senderEmail, "ArtGallery Store"));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(recipientEmail));
            message.setSubject("Xác nhận đơn hàng từ ArtGallery");

            StringBuilder itemsHtml = new StringBuilder();
            for (OrderItem item : orderItems) {
                itemsHtml.append("<tr>")
                        .append("<td>").append(item.getName()).append("</td>")
                        .append("<td><img src='").append(item.getImageUrlCloud()).append("' width='80'/></td>")
                        .append("<td>").append(String.format("%,.0f ₫", item.getPrice() / item.getQuantity())).append("</td>")
                        .append("<td>").append(item.getQuantity()).append("</td>")
                        .append("<td>").append(String.format("%,.0f ₫", item.getPrice())).append("</td>")   // db đã x sl
                        .append("</tr>");
            }

            String htmlContent = "" +
                    "<html><body style=\"font-family: Arial, sans-serif; line-height: 1.6; color: #333;\">" +
                    "<h2 style=\"color: #2c3e50;\">Cảm ơn bạn đã đặt hàng tại <strong>ArtGallery</strong>!</h2>" +
                    "<p>Xin chào <strong>" + order.getRecipientName() + "</strong>,</p>" +
                    "<p>Chúng tôi đã nhận được đơn hàng của bạn và đang tiến hành xử lý.</p>" +

                    "<h3>Thông tin đơn hàng:</h3>" +
                    "<table cellpadding=\"8\" cellspacing=\"0\" border=\"1\" style=\"border-collapse: collapse; width: 100%;\">" +
                    "<tr style=\"background-color: #f2f2f2;\">" +
                    "<th>Sản phẩm</th><th>Ảnh</th><th>Đơn giá</th><th>Số lượng</th><th>Thành tiền</th>" +
                    "</tr>" +
                    itemsHtml +
                    "</table>" +

                    "<p><strong>Mã đơn hàng:</strong> " + order.getId() + "<br>" +
                    "<strong>Ngày đặt:</strong> " + order.getOrderDate() + "<br>" +
                    "<strong>Phương thức thanh toán:</strong> " + order.getPaymentMethod() + "<br>" +
                    "<strong>Phí giao hàng:</strong> " + String.format("%,.0f ₫", order.getShippingFee()) + "<br>" +
                    (!appliedVoucherCodes.isEmpty()
                            ? "<strong>Voucher đã áp dụng:</strong> " + appliedVoucherCodes + "<br>" : "") +
                    "<strong>Tổng cộng:</strong> <span style=\"color: #e74c3c; font-size: 1.2em;\">" +
                    String.format("%,.0f ₫", order.getPriceAfterShipping()) + "</span></p>" +

                    "<h3>Thông tin giao hàng:</h3>" +
                    "<p>" + order.getDeliveryAddress() + "<br>" +
                    "SĐT: " + order.getRecipientPhone() + "</p>" +

                    "<p style=\"margin-top: 30px;\">Nếu bạn có bất kỳ câu hỏi nào, vui lòng liên hệ với chúng tôi qua Fanpage hoặc hotline hỗ trợ.</p>" +
                    "<p style=\"color: #888;\">— Đội ngũ ArtGallery</p>" +
                    "</body></html>";

            message.setContent(htmlContent, "text/html; charset=utf-8");
            Transport.send(message);

            System.out.println("Đã gửi email xác nhận đơn hàng đến: " + recipientEmail);

        } catch (Exception e) {
            System.out.println("Gửi email xác nhận thất bại: " + e.getMessage());
            e.printStackTrace();
        }
    }
}
