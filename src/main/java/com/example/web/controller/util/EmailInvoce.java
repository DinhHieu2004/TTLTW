package com.example.web.controller.util;

import javax.mail.*;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeBodyPart;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeMultipart;
import java.io.File;
import java.util.Properties;

public class EmailInvoce {
    public static void sendInvoice(String recipientEmail, String subject, String messageText, File pdfFile) {
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
            message.setFrom(new InternetAddress(senderEmail));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(recipientEmail));
            message.setSubject(subject);

            // Log debug
            System.out.println("Gửi đến: " + recipientEmail);
            System.out.println("File đính kèm: " + pdfFile.getAbsolutePath());
            System.out.println("File tồn tại? " + (pdfFile.exists() ? "YES" : "NO"));

            // Nội dung
            MimeBodyPart textPart = new MimeBodyPart();
            textPart.setText(messageText);

            // File đính kèm
            MimeBodyPart attachmentPart = new MimeBodyPart();
            attachmentPart.attachFile(pdfFile);

            Multipart multipart = new MimeMultipart();
            multipart.addBodyPart(textPart);
            multipart.addBodyPart(attachmentPart);

            message.setContent(multipart);

            // Gửi email
            Transport.send(message);
            System.out.println("Gửi email thành công!");

        } catch (Exception e) {
            System.out.println("Gửi email thất bại: " + e.getMessage());
            e.printStackTrace();
        }
    }
}
