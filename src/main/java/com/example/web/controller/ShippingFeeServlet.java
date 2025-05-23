package com.example.web.controller;
import com.example.web.dao.cart.Cart;
import com.example.web.dao.cart.CartPainting;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.util.logging.Logger;

@WebServlet("/api/shipping-fee")
public class ShippingFeeServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(ShippingFeeServlet.class.getName());

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json; charset=UTF-8");

        String province = request.getParameter("province");
        String district = request.getParameter("district");
        String address = request.getParameter("address");

      //  String weight = request.getParameter("weight") != null ? request.getParameter("weight") : "1000";
      //  String value = request.getParameter("value") != null ? request.getParameter("value") : "3000000";

     //   System.out.println(province + " " + district + " " + address + " " + weight + " " + value);

        if (province == null || district == null || address == null ||
                province.trim().isEmpty() || district.trim().isEmpty() || address.trim().isEmpty()) {
            response.getWriter().write("{\"success\": false, \"message\": \"Thiếu thông tin địa chỉ nhận hàng.\"}");
            return;
        }

        Cart cart = (Cart) request.getSession().getAttribute("cart");

        double totalWeight = calcWeightAndValue(cart);

        double value = cart.getFinalPrice();

        LOGGER.info("Province: " + province);
        LOGGER.info("District: " + district);
        LOGGER.info("Address: " + address);
        LOGGER.info("Weight: " + totalWeight);
        LOGGER.info("Value: " + value);

        PrintWriter out = response.getWriter();

        try {
            String ghtkUrl = "https://services.giaohangtietkiem.vn/services/shipment/fee"
                    + "?pick_province=" + URLEncoder.encode("Hà Nội", "UTF-8")
                    + "&pick_district=" + URLEncoder.encode("Quận Hai Bà Trưng", "UTF-8")
                    + "&province=" + URLEncoder.encode(province, "UTF-8")
                    + "&district=" + URLEncoder.encode(district, "UTF-8")
                    + "&address=" + URLEncoder.encode(address, "UTF-8")
                    + "&weight=" + URLEncoder.encode(String.valueOf(totalWeight), "UTF-8")
                    + "&value=" + URLEncoder.encode(String.valueOf(value), "UTF-8");

            LOGGER.info("GHTK URL: " + ghtkUrl);

            HttpURLConnection conn = (HttpURLConnection) new URL(ghtkUrl).openConnection();
            conn.setRequestMethod("GET");
            conn.setRequestProperty("Token", "1L59F1G13YAy3rlL2pLioLZLxaYV14ifJgQt4Et");
            conn.setConnectTimeout(10000);
            conn.setReadTimeout(10000);

            int responseCode = conn.getResponseCode();
            LOGGER.info("GHTK Response Code: " + responseCode);

            BufferedReader reader = new BufferedReader(
                    new InputStreamReader(
                            responseCode == 200 ? conn.getInputStream() : conn.getErrorStream(), "UTF-8"));

            StringBuilder result = new StringBuilder();
            String line;
            while ((line = reader.readLine()) != null) {
                result.append(line);
            }

            LOGGER.info("GHTK Response Body: " + result.toString());

            if (responseCode == 200) {
                String responseBody = result.toString();

                try {
                    JsonObject json = JsonParser.parseString(responseBody).getAsJsonObject();
                    if (json.get("success").getAsBoolean() && json.has("fee")) {
                        JsonObject feeObj = json.getAsJsonObject("fee");

                        double fee = feeObj.get("fee").getAsDouble();
                        double insuranceFee = feeObj.has("insurance_fee")
                                ? feeObj.get("insurance_fee").getAsDouble()
                                : 0.0;

                        double totalFee = fee + insuranceFee;

                        request.getSession().setAttribute("shippingFee", totalFee);
                    }
                } catch (Exception e) {
                    LOGGER.warning("Không thể parse JSON bằng Gson: " + e.getMessage());
                }

                out.write(responseBody);
            }
        } catch (Exception e) {
            LOGGER.severe("Exception: " + e.getMessage());
            out.write("{\"success\": false, \"message\": \"Lỗi kết nối đến GHTK: " + e.getMessage() + "\"}");
        } finally {
            out.flush();
            out.close();
        }
    }
    private double calcWeightAndValue(Cart cart){
            if (cart == null || cart.getItems() == null)
                return 0.0;

            double totalWeight = 0.0;

            for (CartPainting item : cart.getItems()) {
                totalWeight += item.getWeight() * item.getQuantity();
            }
        return totalWeight;
    }
}
