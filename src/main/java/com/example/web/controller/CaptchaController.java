package com.example.web.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import javax.imageio.ImageIO;
import java.awt.*;
import java.awt.image.BufferedImage;
import java.io.IOException;
import java.util.Random;

@WebServlet(name = "CaptchaController", value = "/captcha")
public class CaptchaController extends HttpServlet {

    private static final int WIDTH = 160;
    private static final int HEIGHT = 40;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        BufferedImage captchaImage = new BufferedImage(WIDTH, HEIGHT, BufferedImage.TYPE_INT_RGB);
        Graphics2D g = captchaImage.createGraphics();

        g.setColor(Color.WHITE);
        g.fillRect(0, 0, WIDTH, HEIGHT);

        Random random = new Random();

        // Vẽ đường nhiễu
        g.setColor(Color.GRAY);
        for (int i = 0; i < 15; i++) {
            int x1 = random.nextInt(WIDTH);
            int y1 = random.nextInt(HEIGHT);
            int x2 = random.nextInt(WIDTH);
            int y2 = random.nextInt(HEIGHT);
            g.drawLine(x1, y1, x2, y2);
        }

        String captchaText = generateCaptchaText(6);
        HttpSession session = request.getSession();
        session.setAttribute("captcha", captchaText);
        session.setAttribute("captchaCreationTime", System.currentTimeMillis());

        g.setFont(new Font("Arial", Font.BOLD, 28));
        FontMetrics fontMetrics = g.getFontMetrics();

        int x = 10;
        for (int i = 0; i < captchaText.length(); i++) {
            g.setColor(new Color(random.nextInt(150), random.nextInt(150), random.nextInt(150)));

            char c = captchaText.charAt(i);
            int charWidth = fontMetrics.charWidth(c);
            int y = 30 + random.nextInt(5);

            g.drawString(String.valueOf(c), x, y);
            x += charWidth + 5;
        }

        for (int i = 0; i < 100; i++) {
            int px = random.nextInt(WIDTH);
            int py = random.nextInt(HEIGHT);
            g.drawRect(px, py, 1, 1);
        }

        g.dispose();

        response.setContentType("image/png");
        ImageIO.write(captchaImage, "png", response.getOutputStream());
    }

    private String generateCaptchaText(int length) {
        String chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
        StringBuilder captchaText = new StringBuilder();

        Random random = new Random();
        for (int i = 0; i < length; i++) {
            captchaText.append(chars.charAt(random.nextInt(chars.length())));
        }
        return captchaText.toString();
    }
}
