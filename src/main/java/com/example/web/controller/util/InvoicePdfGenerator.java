package com.example.web.controller.util;

import com.example.web.dao.model.Order;
import com.example.web.dao.model.OrderItem;
import com.itextpdf.text.*;
import com.itextpdf.text.pdf.*;
import java.io.FileOutputStream;
import java.util.List;

public class InvoicePdfGenerator {
    public static void generate(Order order, List<OrderItem> items) throws Exception {
        Document document = new Document();
        String filename = "invoice_" + order.getVnpTxnRef() + ".pdf";
        PdfWriter.getInstance(document, new FileOutputStream(filename));
        document.open();

        // Tiêu đề
        Font titleFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 16);
        Paragraph title = new Paragraph("HÓA ĐƠN BÁN HÀNG", titleFont);
        title.setAlignment(Element.ALIGN_CENTER);
        document.add(title);
        document.add(new Paragraph(" ")); // khoảng trắng

        // Thông tin đơn hàng
        document.add(new Paragraph("Mã hóa đơn: " + order.getVnpTxnRef()));
        document.add(new Paragraph("Ngày đặt: " + order.getOrderDate()));
        document.add(new Paragraph("Khách hàng: " + order.getRecipientName()));
        document.add(new Paragraph("SĐT: " + order.getRecipientPhone()));
        document.add(new Paragraph("Địa chỉ giao hàng: " + order.getDeliveryAddress()));
        document.add(new Paragraph(" "));

        // Bảng sản phẩm
        PdfPTable table = new PdfPTable(4); // STT, Tên, SL, Đơn giá, Thành tiền
        table.setWidthPercentage(100);
        table.setSpacingBefore(10f);

        // Header
        table.addCell("STT");
        table.addCell("Tên sản phẩm");
        table.addCell("Số lượng");
        table.addCell("Đơn giá");

        int index = 1;
        for (OrderItem item : items) {
            table.addCell(String.valueOf(index++));
            table.addCell(item.getName());
            table.addCell(String.valueOf(item.getQuantity()));
            table.addCell(String.format("%,.0f ₫", item.getPrice()));
        }

        document.add(table);

        // Tổng kết
        document.add(new Paragraph(" "));
        document.add(new Paragraph("Tổng tiền sản phẩm: " + String.format("%,.0f ₫", order.getTotalAmount())));
        document.add(new Paragraph("Phí giao hàng: " + String.format("%,.0f ₫", order.getShippingFee())));
        document.add(new Paragraph("Tổng cộng: " + String.format("%,.0f ₫", order.getPriceAfterShipping())));

        document.close();
        System.out.println("Hóa đơn đã được tạo: " + filename);
    }
}

